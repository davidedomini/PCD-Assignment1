------------------------------- MODULE Ass01 -------------------------------
EXTENDS Integers, Sequences

(*--algorithm Ass01

variables 
    iter = 0,
    maxIter = 10,
    processReady = 0,
    allReady = FALSE;
    updatedVelocity = 0,
    updatedPosition = 0,
    nWorkers = 2,
    body = [pos |-> 0, vel |-> 1],
    bodies = <<body, body, body, body >>;
    
\*define  todo 
    \*NoOverdrafts == \A p \in people: acc[p] >= 0
    \*EventuallyConsistent == <>[](acc["alice"] + acc["bob"] = 10)
\*end define;

\*MASTER
fair+ process Master = "master"
begin
    IncReadyToStart: processReady := processReady + 1;
    ReadyToStart: 
        if processReady = 3 then
            allReady := TRUE;
        else
            await allReady;
            \*resetPR: processReady := 0;
        end if;
    UpdatedVel: 
      updatedVelocity := updatedVelocity + 1;
      await updatedVelocity = 3 ;
            \*resetUV: updatedVelocity := 0;
    UpdatedPos: 
      updatedPosition := updatedPosition + 1;
      await updatedPosition = 3 ;
             \*resetUP: updatedPosition := 0;
    NewIter: iter := iter + 1;
end process;

\*WORKER 1
fair+ process Worker1 = "worker1"
begin
   IncReadyToStart: processReady := processReady + 1;
   ReadyToStartW1: 
        if processReady = 3 then
            allReady := TRUE;
        else
            await allReady;
        end if;
   UpdVelB1: 
      bodies[1].vel := bodies[1].vel + 1;
   UpdVelB2: 
      bodies[2].vel := bodies[2].vel + 1;
   UpdatedVelW1: 
      updatedVelocity := updatedVelocity + 1;
      await updatedVelocity = 3;
   UpdPosB1:
      bodies[1].pos := bodies[1].pos + 1;
   UpdPosB2:
      bodies[2].pos := bodies[2].pos + 1;
   UpdatedPos: 
      updatedPosition := updatedPosition + 1;
      await updatedPosition = 3;
end process;

\*WORKER 2
fair+ process Worker2 = "worker2"
begin
   IncReadyToStart: processReady := processReady + 1;
   ReadyToStartW2: 
        if processReady = 3 then
            allReady := TRUE;
        else
            await allReady;
        end if;
   UpdVelB3: 
      bodies[3].vel := bodies[3].vel + 1;
   UpdVelB4: 
      bodies[4].vel := bodies[4].vel + 1;
   UpdatedVelW2: 
      updatedVelocity := updatedVelocity + 1;
      await updatedVelocity = 3;
   UpdPosB3:
      bodies[3].pos := bodies[3].pos + 1;
   UpdPosB4:
      bodies[4].pos := bodies[4].pos + 1;
   UpdatedPosW2: 
      updatedPosition := updatedPosition + 1;
      await updatedPosition = 3;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "58e48f39" /\ chksum(tla) = "3bf0fb72")
\* Label IncReadyToStart of process Master at line 25 col 22 changed to IncReadyToStart_
\* Label UpdatedPos of process Master at line 38 col 7 changed to UpdatedPos_
\* Label IncReadyToStart of process Worker1 at line 47 col 21 changed to IncReadyToStart_W
VARIABLES iter, maxIter, processReady, allReady, updatedVelocity, 
          updatedPosition, nWorkers, body, bodies, pc

vars == << iter, maxIter, processReady, allReady, updatedVelocity, 
           updatedPosition, nWorkers, body, bodies, pc >>

ProcSet == {"master"} \cup {"worker1"} \cup {"worker2"}

Init == (* Global variables *)
        /\ iter = 0
        /\ maxIter = 10
        /\ processReady = 0
        /\ allReady = FALSE
        /\ updatedVelocity = 0
        /\ updatedPosition = 0
        /\ nWorkers = 2
        /\ body = [pos |-> 0, vel |-> 1]
        /\ bodies = <<body, body, body, body >>
        /\ pc = [self \in ProcSet |-> CASE self = "master" -> "IncReadyToStart_"
                                        [] self = "worker1" -> "IncReadyToStart_W"
                                        [] self = "worker2" -> "IncReadyToStart"]

IncReadyToStart_ == /\ pc["master"] = "IncReadyToStart_"
                    /\ processReady' = processReady + 1
                    /\ pc' = [pc EXCEPT !["master"] = "ReadyToStart"]
                    /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                    updatedPosition, nWorkers, body, bodies >>

ReadyToStart == /\ pc["master"] = "ReadyToStart"
                /\ IF processReady = 3
                      THEN /\ allReady' = TRUE
                      ELSE /\ allReady
                           /\ UNCHANGED allReady
                /\ pc' = [pc EXCEPT !["master"] = "UpdatedVel"]
                /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                updatedPosition, nWorkers, body, bodies >>

UpdatedVel == /\ pc["master"] = "UpdatedVel"
              /\ updatedVelocity' = updatedVelocity + 1
              /\ updatedVelocity' = 3
              /\ pc' = [pc EXCEPT !["master"] = "UpdatedPos_"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedPosition, nWorkers, body, bodies >>

UpdatedPos_ == /\ pc["master"] = "UpdatedPos_"
               /\ updatedPosition' = updatedPosition + 1
               /\ updatedPosition' = 3
               /\ pc' = [pc EXCEPT !["master"] = "NewIter"]
               /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                               updatedVelocity, nWorkers, body, bodies >>

NewIter == /\ pc["master"] = "NewIter"
           /\ iter' = iter + 1
           /\ pc' = [pc EXCEPT !["master"] = "Done"]
           /\ UNCHANGED << maxIter, processReady, allReady, updatedVelocity, 
                           updatedPosition, nWorkers, body, bodies >>

Master == IncReadyToStart_ \/ ReadyToStart \/ UpdatedVel \/ UpdatedPos_
             \/ NewIter

IncReadyToStart_W == /\ pc["worker1"] = "IncReadyToStart_W"
                     /\ processReady' = processReady + 1
                     /\ pc' = [pc EXCEPT !["worker1"] = "ReadyToStartW1"]
                     /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                     updatedPosition, nWorkers, body, bodies >>

ReadyToStartW1 == /\ pc["worker1"] = "ReadyToStartW1"
                  /\ IF processReady = 3
                        THEN /\ allReady' = TRUE
                        ELSE /\ allReady
                             /\ UNCHANGED allReady
                  /\ pc' = [pc EXCEPT !["worker1"] = "UpdVelB1"]
                  /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                  updatedPosition, nWorkers, body, bodies >>

UpdVelB1 == /\ pc["worker1"] = "UpdVelB1"
            /\ bodies' = [bodies EXCEPT ![1].vel = bodies[1].vel + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdVelB2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdVelB2 == /\ pc["worker1"] = "UpdVelB2"
            /\ bodies' = [bodies EXCEPT ![2].vel = bodies[2].vel + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdatedVelW1"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdatedVelW1 == /\ pc["worker1"] = "UpdatedVelW1"
                /\ updatedVelocity' = updatedVelocity + 1
                /\ updatedVelocity' = 3
                /\ pc' = [pc EXCEPT !["worker1"] = "UpdPosB1"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedPosition, nWorkers, body, bodies >>

UpdPosB1 == /\ pc["worker1"] = "UpdPosB1"
            /\ bodies' = [bodies EXCEPT ![1].pos = bodies[1].pos + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdPosB2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdPosB2 == /\ pc["worker1"] = "UpdPosB2"
            /\ bodies' = [bodies EXCEPT ![2].pos = bodies[2].pos + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdatedPos"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdatedPos == /\ pc["worker1"] = "UpdatedPos"
              /\ updatedPosition' = updatedPosition + 1
              /\ updatedPosition' = 3
              /\ pc' = [pc EXCEPT !["worker1"] = "Done"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedVelocity, nWorkers, body, bodies >>

Worker1 == IncReadyToStart_W \/ ReadyToStartW1 \/ UpdVelB1 \/ UpdVelB2
              \/ UpdatedVelW1 \/ UpdPosB1 \/ UpdPosB2 \/ UpdatedPos

IncReadyToStart == /\ pc["worker2"] = "IncReadyToStart"
                   /\ processReady' = processReady + 1
                   /\ pc' = [pc EXCEPT !["worker2"] = "ReadyToStartW2"]
                   /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                   updatedPosition, nWorkers, body, bodies >>

ReadyToStartW2 == /\ pc["worker2"] = "ReadyToStartW2"
                  /\ IF processReady = 3
                        THEN /\ allReady' = TRUE
                        ELSE /\ allReady
                             /\ UNCHANGED allReady
                  /\ pc' = [pc EXCEPT !["worker2"] = "UpdVelB3"]
                  /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                  updatedPosition, nWorkers, body, bodies >>

UpdVelB3 == /\ pc["worker2"] = "UpdVelB3"
            /\ bodies' = [bodies EXCEPT ![3].vel = bodies[3].vel + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdVelB4"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdVelB4 == /\ pc["worker2"] = "UpdVelB4"
            /\ bodies' = [bodies EXCEPT ![4].vel = bodies[4].vel + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdatedVelW2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdatedVelW2 == /\ pc["worker2"] = "UpdatedVelW2"
                /\ updatedVelocity' = updatedVelocity + 1
                /\ updatedVelocity' = 3
                /\ pc' = [pc EXCEPT !["worker2"] = "UpdPosB3"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedPosition, nWorkers, body, bodies >>

UpdPosB3 == /\ pc["worker2"] = "UpdPosB3"
            /\ bodies' = [bodies EXCEPT ![3].pos = bodies[3].pos + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdPosB4"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdPosB4 == /\ pc["worker2"] = "UpdPosB4"
            /\ bodies' = [bodies EXCEPT ![4].pos = bodies[4].pos + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdatedPosW2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, updatedPosition, nWorkers, body >>

UpdatedPosW2 == /\ pc["worker2"] = "UpdatedPosW2"
                /\ updatedPosition' = updatedPosition + 1
                /\ updatedPosition' = 3
                /\ pc' = [pc EXCEPT !["worker2"] = "Done"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, nWorkers, body, bodies >>

Worker2 == IncReadyToStart \/ ReadyToStartW2 \/ UpdVelB3 \/ UpdVelB4
              \/ UpdatedVelW2 \/ UpdPosB3 \/ UpdPosB4 \/ UpdatedPosW2

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == Master \/ Worker1 \/ Worker2
           \/ Terminating

Spec == /\ Init /\ [][Next]_vars
        /\ SF_vars(Master)
        /\ SF_vars(Worker1)
        /\ SF_vars(Worker2)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
=============================================================================
\* Modification History
\* Last modified Wed Mar 30 09:34:49 CEST 2022 by davidedomini
\* Created Tue Mar 29 20:19:23 CEST 2022 by davidedomini
