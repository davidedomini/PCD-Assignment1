------------------------------- MODULE Ass01 -------------------------------
EXTENDS Integers, Sequences

(*--algorithm Ass01

variables 
    iter = 0,
    maxIter = 10,
    processReady = 0,
    allReady = FALSE;
    updatedVelocity = 0,
    allVelocitiesUpdated = FALSE,
    updatedPosition = 0,
    allPositionsUpdated = FALSE,
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
    \*Aspetto che tutti i worker siano pronti a partire
    IncReadyToStart: processReady := processReady + 1;
    ReadyToStart: 
        if processReady = 3 then
            allReady := TRUE;
        else
            await allReady;
        end if;
    \*Aspetto che tutti i worker abbiano fatto l'update delle velocità
    IncUpdatedVelocity: updatedVelocity := updatedVelocity + 1;
    UpdatedVel: 
        if updatedVelocity = 3 then
            allVelocitiesUpdated := TRUE;
        else
            await allVelocitiesUpdated;
        end if;
    \*Aspetto che tutti i worker abbiano fatto l'update delle posizioni
    IncUpdatedPosition: updatedPosition := updatedPosition + 1;
    UpdatedPos: 
        if updatedPosition = 3 then
            allPositionsUpdated := TRUE;
        else
            await allPositionsUpdated;
        end if;
    \* Aggiorno l'iterazione
    NewIter: iter := iter + 1;
end process;

\*WORKER 1
fair+ process Worker1 = "worker1"
begin
   \*Aspetto che tutti siano pronti
   IncReadyToStartW1: processReady := processReady + 1;
   ReadyToStartW1: 
        if processReady = 3 then
            allReady := TRUE;
        else
            await allReady;
        end if;
   \*Aggiorno le velocità dei body che mi sono stati assegnati
   UpdVelB1: 
      bodies[1].vel := bodies[1].vel + 1;
   UpdVelB2: 
      bodies[2].vel := bodies[2].vel + 1;
   IncUpdatedVelw1: updatedVelocity := updatedVelocity + 1;
   \*Aspetto che tutti i worker abbiano finito di aggiornare le velocità
   UpdatedVelW1: 
      if updatedVelocity = 3 then
        allVelocitiesUpdated := TRUE;
      else
        await allVelocitiesUpdated;
      end if;
   \*Aggiorno le posizioni dei body che mi sono stati assegnati
   UpdPosB1:
      bodies[1].pos := bodies[1].pos + 1;
   UpdPosB2:
      bodies[2].pos := bodies[2].pos + 1;
   IncUpdatedPosW1: updatedPosition := updatedPosition + 1;
   \*Aspetto che tutti i worker abbiano finito di aggiornare le posizioni
   UpdatedPos: 
      if updatedPosition = 3 then
        allPositionsUpdated := TRUE;
      else
        await allPositionsUpdated;
     end if;
end process;

\*WORKER 2
fair+ process Worker2 = "worker2"
begin
   \*Aspetto che tutti siano pronti
   IncReadyToStartW2: processReady := processReady + 1;
   ReadyToStartW2: 
        if processReady = 3 then
            allReady := TRUE;
        else
            await allReady;
        end if;
   \*Aggiorno le velocità dei body che mi sono stati assegnati
   UpdVelB3: 
      bodies[3].vel := bodies[3].vel + 1;
   UpdVelB4: 
      bodies[4].vel := bodies[4].vel + 1;
   IncUpdatedVelw2: updatedVelocity := updatedVelocity + 1;
   \*Aspetto che tutti i worker abbiano finito di aggiornare le velocità
   UpdatedVelW2: 
      if updatedVelocity = 3 then
        allVelocitiesUpdated := TRUE;
      else
        await allVelocitiesUpdated;
      end if;
   \*Aggiorno le posizioni dei body che mi sono stati assegnati
   UpdPosB3:
      bodies[3].pos := bodies[3].pos + 1;
   UpdPosB4:
      bodies[4].pos := bodies[4].pos + 1;
   IncUpdatedPosW2: updatedPosition := updatedPosition + 1;
   \*Aspetto che tutti i worker abbiano finito di aggiornare le posizioni
   UpdatedPos: 
      if updatedPosition = 3 then
        allPositionsUpdated := TRUE;
      else
        await allPositionsUpdated;
     end if;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "60138f42" /\ chksum(tla) = "eb1c70ab")
\* Label UpdatedPos of process Master at line 46 col 9 changed to UpdatedPos_
\* Label UpdatedPos of process Worker1 at line 87 col 7 changed to UpdatedPos_W
VARIABLES iter, maxIter, processReady, allReady, updatedVelocity, 
          allVelocitiesUpdated, updatedPosition, allPositionsUpdated, 
          nWorkers, body, bodies, pc

vars == << iter, maxIter, processReady, allReady, updatedVelocity, 
           allVelocitiesUpdated, updatedPosition, allPositionsUpdated, 
           nWorkers, body, bodies, pc >>

ProcSet == {"master"} \cup {"worker1"} \cup {"worker2"}

Init == (* Global variables *)
        /\ iter = 0
        /\ maxIter = 10
        /\ processReady = 0
        /\ allReady = FALSE
        /\ updatedVelocity = 0
        /\ allVelocitiesUpdated = FALSE
        /\ updatedPosition = 0
        /\ allPositionsUpdated = FALSE
        /\ nWorkers = 2
        /\ body = [pos |-> 0, vel |-> 1]
        /\ bodies = <<body, body, body, body >>
        /\ pc = [self \in ProcSet |-> CASE self = "master" -> "IncReadyToStart"
                                        [] self = "worker1" -> "IncReadyToStartW1"
                                        [] self = "worker2" -> "IncReadyToStartW2"]

IncReadyToStart == /\ pc["master"] = "IncReadyToStart"
                   /\ processReady' = processReady + 1
                   /\ pc' = [pc EXCEPT !["master"] = "ReadyToStart"]
                   /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                   allVelocitiesUpdated, updatedPosition, 
                                   allPositionsUpdated, nWorkers, body, bodies >>

ReadyToStart == /\ pc["master"] = "ReadyToStart"
                /\ IF processReady = 3
                      THEN /\ allReady' = TRUE
                      ELSE /\ allReady
                           /\ UNCHANGED allReady
                /\ pc' = [pc EXCEPT !["master"] = "IncUpdatedVelocity"]
                /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                allVelocitiesUpdated, updatedPosition, 
                                allPositionsUpdated, nWorkers, body, bodies >>

IncUpdatedVelocity == /\ pc["master"] = "IncUpdatedVelocity"
                      /\ updatedVelocity' = updatedVelocity + 1
                      /\ pc' = [pc EXCEPT !["master"] = "UpdatedVel"]
                      /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                      allVelocitiesUpdated, updatedPosition, 
                                      allPositionsUpdated, nWorkers, body, 
                                      bodies >>

UpdatedVel == /\ pc["master"] = "UpdatedVel"
              /\ IF updatedVelocity = 3
                    THEN /\ allVelocitiesUpdated' = TRUE
                    ELSE /\ allVelocitiesUpdated
                         /\ UNCHANGED allVelocitiesUpdated
              /\ pc' = [pc EXCEPT !["master"] = "IncUpdatedPosition"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedVelocity, updatedPosition, 
                              allPositionsUpdated, nWorkers, body, bodies >>

IncUpdatedPosition == /\ pc["master"] = "IncUpdatedPosition"
                      /\ updatedPosition' = updatedPosition + 1
                      /\ pc' = [pc EXCEPT !["master"] = "UpdatedPos_"]
                      /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                      updatedVelocity, allVelocitiesUpdated, 
                                      allPositionsUpdated, nWorkers, body, 
                                      bodies >>

UpdatedPos_ == /\ pc["master"] = "UpdatedPos_"
               /\ IF updatedPosition = 3
                     THEN /\ allPositionsUpdated' = TRUE
                     ELSE /\ allPositionsUpdated
                          /\ UNCHANGED allPositionsUpdated
               /\ pc' = [pc EXCEPT !["master"] = "NewIter"]
               /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                               updatedVelocity, allVelocitiesUpdated, 
                               updatedPosition, nWorkers, body, bodies >>

NewIter == /\ pc["master"] = "NewIter"
           /\ iter' = iter + 1
           /\ pc' = [pc EXCEPT !["master"] = "Done"]
           /\ UNCHANGED << maxIter, processReady, allReady, updatedVelocity, 
                           allVelocitiesUpdated, updatedPosition, 
                           allPositionsUpdated, nWorkers, body, bodies >>

Master == IncReadyToStart \/ ReadyToStart \/ IncUpdatedVelocity
             \/ UpdatedVel \/ IncUpdatedPosition \/ UpdatedPos_ \/ NewIter

IncReadyToStartW1 == /\ pc["worker1"] = "IncReadyToStartW1"
                     /\ processReady' = processReady + 1
                     /\ pc' = [pc EXCEPT !["worker1"] = "ReadyToStartW1"]
                     /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                     allVelocitiesUpdated, updatedPosition, 
                                     allPositionsUpdated, nWorkers, body, 
                                     bodies >>

ReadyToStartW1 == /\ pc["worker1"] = "ReadyToStartW1"
                  /\ IF processReady = 3
                        THEN /\ allReady' = TRUE
                        ELSE /\ allReady
                             /\ UNCHANGED allReady
                  /\ pc' = [pc EXCEPT !["worker1"] = "UpdVelB1"]
                  /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                  allVelocitiesUpdated, updatedPosition, 
                                  allPositionsUpdated, nWorkers, body, bodies >>

UpdVelB1 == /\ pc["worker1"] = "UpdVelB1"
            /\ bodies' = [bodies EXCEPT ![1].vel = bodies[1].vel + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdVelB2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

UpdVelB2 == /\ pc["worker1"] = "UpdVelB2"
            /\ bodies' = [bodies EXCEPT ![2].vel = bodies[2].vel + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "IncUpdatedVelw1"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

IncUpdatedVelw1 == /\ pc["worker1"] = "IncUpdatedVelw1"
                   /\ updatedVelocity' = updatedVelocity + 1
                   /\ pc' = [pc EXCEPT !["worker1"] = "UpdatedVelW1"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   allVelocitiesUpdated, updatedPosition, 
                                   allPositionsUpdated, nWorkers, body, bodies >>

UpdatedVelW1 == /\ pc["worker1"] = "UpdatedVelW1"
                /\ IF updatedVelocity = 3
                      THEN /\ allVelocitiesUpdated' = TRUE
                      ELSE /\ allVelocitiesUpdated
                           /\ UNCHANGED allVelocitiesUpdated
                /\ pc' = [pc EXCEPT !["worker1"] = "UpdPosB1"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, updatedPosition, 
                                allPositionsUpdated, nWorkers, body, bodies >>

UpdPosB1 == /\ pc["worker1"] = "UpdPosB1"
            /\ bodies' = [bodies EXCEPT ![1].pos = bodies[1].pos + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdPosB2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

UpdPosB2 == /\ pc["worker1"] = "UpdPosB2"
            /\ bodies' = [bodies EXCEPT ![2].pos = bodies[2].pos + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "IncUpdatedPosW1"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

IncUpdatedPosW1 == /\ pc["worker1"] = "IncUpdatedPosW1"
                   /\ updatedPosition' = updatedPosition + 1
                   /\ pc' = [pc EXCEPT !["worker1"] = "UpdatedPos_W"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   updatedVelocity, allVelocitiesUpdated, 
                                   allPositionsUpdated, nWorkers, body, bodies >>

UpdatedPos_W == /\ pc["worker1"] = "UpdatedPos_W"
                /\ IF updatedPosition = 3
                      THEN /\ allPositionsUpdated' = TRUE
                      ELSE /\ allPositionsUpdated
                           /\ UNCHANGED allPositionsUpdated
                /\ pc' = [pc EXCEPT !["worker1"] = "Done"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, allVelocitiesUpdated, 
                                updatedPosition, nWorkers, body, bodies >>

Worker1 == IncReadyToStartW1 \/ ReadyToStartW1 \/ UpdVelB1 \/ UpdVelB2
              \/ IncUpdatedVelw1 \/ UpdatedVelW1 \/ UpdPosB1 \/ UpdPosB2
              \/ IncUpdatedPosW1 \/ UpdatedPos_W

IncReadyToStartW2 == /\ pc["worker2"] = "IncReadyToStartW2"
                     /\ processReady' = processReady + 1
                     /\ pc' = [pc EXCEPT !["worker2"] = "ReadyToStartW2"]
                     /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                     allVelocitiesUpdated, updatedPosition, 
                                     allPositionsUpdated, nWorkers, body, 
                                     bodies >>

ReadyToStartW2 == /\ pc["worker2"] = "ReadyToStartW2"
                  /\ IF processReady = 3
                        THEN /\ allReady' = TRUE
                        ELSE /\ allReady
                             /\ UNCHANGED allReady
                  /\ pc' = [pc EXCEPT !["worker2"] = "UpdVelB3"]
                  /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                  allVelocitiesUpdated, updatedPosition, 
                                  allPositionsUpdated, nWorkers, body, bodies >>

UpdVelB3 == /\ pc["worker2"] = "UpdVelB3"
            /\ bodies' = [bodies EXCEPT ![3].vel = bodies[3].vel + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdVelB4"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

UpdVelB4 == /\ pc["worker2"] = "UpdVelB4"
            /\ bodies' = [bodies EXCEPT ![4].vel = bodies[4].vel + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "IncUpdatedVelw2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

IncUpdatedVelw2 == /\ pc["worker2"] = "IncUpdatedVelw2"
                   /\ updatedVelocity' = updatedVelocity + 1
                   /\ pc' = [pc EXCEPT !["worker2"] = "UpdatedVelW2"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   allVelocitiesUpdated, updatedPosition, 
                                   allPositionsUpdated, nWorkers, body, bodies >>

UpdatedVelW2 == /\ pc["worker2"] = "UpdatedVelW2"
                /\ IF updatedVelocity = 3
                      THEN /\ allVelocitiesUpdated' = TRUE
                      ELSE /\ allVelocitiesUpdated
                           /\ UNCHANGED allVelocitiesUpdated
                /\ pc' = [pc EXCEPT !["worker2"] = "UpdPosB3"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, updatedPosition, 
                                allPositionsUpdated, nWorkers, body, bodies >>

UpdPosB3 == /\ pc["worker2"] = "UpdPosB3"
            /\ bodies' = [bodies EXCEPT ![3].pos = bodies[3].pos + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdPosB4"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

UpdPosB4 == /\ pc["worker2"] = "UpdPosB4"
            /\ bodies' = [bodies EXCEPT ![4].pos = bodies[4].pos + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "IncUpdatedPosW2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, nWorkers, 
                            body >>

IncUpdatedPosW2 == /\ pc["worker2"] = "IncUpdatedPosW2"
                   /\ updatedPosition' = updatedPosition + 1
                   /\ pc' = [pc EXCEPT !["worker2"] = "UpdatedPos"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   updatedVelocity, allVelocitiesUpdated, 
                                   allPositionsUpdated, nWorkers, body, bodies >>

UpdatedPos == /\ pc["worker2"] = "UpdatedPos"
              /\ IF updatedPosition = 3
                    THEN /\ allPositionsUpdated' = TRUE
                    ELSE /\ allPositionsUpdated
                         /\ UNCHANGED allPositionsUpdated
              /\ pc' = [pc EXCEPT !["worker2"] = "Done"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedVelocity, allVelocitiesUpdated, 
                              updatedPosition, nWorkers, body, bodies >>

Worker2 == IncReadyToStartW2 \/ ReadyToStartW2 \/ UpdVelB3 \/ UpdVelB4
              \/ IncUpdatedVelw2 \/ UpdatedVelW2 \/ UpdPosB3 \/ UpdPosB4
              \/ IncUpdatedPosW2 \/ UpdatedPos

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
\* Last modified Wed Mar 30 09:47:17 CEST 2022 by davidedomini
\* Created Tue Mar 29 20:19:23 CEST 2022 by davidedomini
