------------------------------- MODULE Ass01 -------------------------------
EXTENDS Integers, Sequences

(*--algorithm Ass01

variables 
    iter = 0,
    maxIter = 10,
    processReady = 0,       \* Barriera per lo start
    allReady = FALSE, 
    updatedVelocity = 0,    \* Barriera per aspettare l'update delle velocità
    allVelocitiesUpdated = FALSE,
    updatedPosition = 0,    \* Barriera per aspettare l'update delle posizioni
    allPositionsUpdated = FALSE,
    simulationFinished = FALSE, 
    body = [pos |-> 0, vel |-> 1],
    bodies = <<body, body, body, body >>; 

\*MASTER
fair+ process Master = "master"
begin
    MainLoopMaster:
        while iter < maxIter do
            \*Aspetto che tutti i worker siano pronti a partire
            IncReadyToStart: processReady := processReady + 1;
            ReadyToStart: 
                if processReady = 3 then
                    allReady := TRUE;
                else
                    await allReady;
                end if;
                ResetPosBarrier:
                \*Reset position update barrier
                    allPositionsUpdated := FALSE;
                    updatedPosition := 0;
            \*Aspetto che tutti i worker abbiano fatto l'update delle velocità
            IncUpdatedVelocity: updatedVelocity := updatedVelocity + 1;
            UpdatedVel: 
                if updatedVelocity = 3 then
                    allVelocitiesUpdated := TRUE;
                else
                    await allVelocitiesUpdated;
                end if;
                ResetAllReadyBarrier:
                    \*Reset all ready barrier
                    allReady := FALSE;
                    processReady := 0;
            \*Aspetto che tutti i worker abbiano fatto l'update delle posizioni
            IncUpdatedPosition: updatedPosition := updatedPosition + 1;
            UpdatedPos: 
                if updatedPosition = 3 then
                    allPositionsUpdated := TRUE;
                else
                    await allPositionsUpdated;
                end if;
                ResetVelBarrier:
                \*Reset velocity update barrier
                    allVelocitiesUpdated := FALSE;
                    updatedVelocity := 0;
            \* Aggiorno l'iterazione
            NewIter: iter := iter + 1;
        end while;
        
end process;

\*WORKER 1
fair+ process Worker1 = "worker1"
begin
   MainLoopW1:
        while iter < maxIter do 
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
           UpdatedPosW1: 
              if updatedPosition = 3 then
                allPositionsUpdated := TRUE;
              else
                await allPositionsUpdated;
             end if;
         end while;
end process;

\*WORKER 2
fair+ process Worker2 = "worker2"
begin
   MainLoopW2:
        while iter < maxIter do
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
           UpdatedPosW2: 
              if updatedPosition = 3 then
                allPositionsUpdated := TRUE;
              else
                await allPositionsUpdated;
             end if;
        end while;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "63a0b089" /\ chksum(tla) = "180164c2")
VARIABLES iter, maxIter, processReady, allReady, updatedVelocity, 
          allVelocitiesUpdated, updatedPosition, allPositionsUpdated, 
          simulationFinished, body, bodies, pc

vars == << iter, maxIter, processReady, allReady, updatedVelocity, 
           allVelocitiesUpdated, updatedPosition, allPositionsUpdated, 
           simulationFinished, body, bodies, pc >>

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
        /\ simulationFinished = FALSE
        /\ body = [pos |-> 0, vel |-> 1]
        /\ bodies = <<body, body, body, body >>
        /\ pc = [self \in ProcSet |-> CASE self = "master" -> "MainLoopMaster"
                                        [] self = "worker1" -> "MainLoopW1"
                                        [] self = "worker2" -> "MainLoopW2"]

MainLoopMaster == /\ pc["master"] = "MainLoopMaster"
                  /\ IF iter < maxIter
                        THEN /\ pc' = [pc EXCEPT !["master"] = "IncReadyToStart"]
                        ELSE /\ pc' = [pc EXCEPT !["master"] = "Done"]
                  /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                  updatedVelocity, allVelocitiesUpdated, 
                                  updatedPosition, allPositionsUpdated, 
                                  simulationFinished, body, bodies >>

IncReadyToStart == /\ pc["master"] = "IncReadyToStart"
                   /\ processReady' = processReady + 1
                   /\ pc' = [pc EXCEPT !["master"] = "ReadyToStart"]
                   /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                   allVelocitiesUpdated, updatedPosition, 
                                   allPositionsUpdated, simulationFinished, 
                                   body, bodies >>

ReadyToStart == /\ pc["master"] = "ReadyToStart"
                /\ IF processReady = 3
                      THEN /\ allReady' = TRUE
                      ELSE /\ allReady
                           /\ UNCHANGED allReady
                /\ pc' = [pc EXCEPT !["master"] = "ResetPosBarrier"]
                /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                allVelocitiesUpdated, updatedPosition, 
                                allPositionsUpdated, simulationFinished, body, 
                                bodies >>

ResetPosBarrier == /\ pc["master"] = "ResetPosBarrier"
                   /\ allPositionsUpdated' = FALSE
                   /\ updatedPosition' = 0
                   /\ pc' = [pc EXCEPT !["master"] = "IncUpdatedVelocity"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   updatedVelocity, allVelocitiesUpdated, 
                                   simulationFinished, body, bodies >>

IncUpdatedVelocity == /\ pc["master"] = "IncUpdatedVelocity"
                      /\ updatedVelocity' = updatedVelocity + 1
                      /\ pc' = [pc EXCEPT !["master"] = "UpdatedVel"]
                      /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                      allVelocitiesUpdated, updatedPosition, 
                                      allPositionsUpdated, simulationFinished, 
                                      body, bodies >>

UpdatedVel == /\ pc["master"] = "UpdatedVel"
              /\ IF updatedVelocity = 3
                    THEN /\ allVelocitiesUpdated' = TRUE
                    ELSE /\ allVelocitiesUpdated
                         /\ UNCHANGED allVelocitiesUpdated
              /\ pc' = [pc EXCEPT !["master"] = "ResetAllReadyBarrier"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedVelocity, updatedPosition, 
                              allPositionsUpdated, simulationFinished, body, 
                              bodies >>

ResetAllReadyBarrier == /\ pc["master"] = "ResetAllReadyBarrier"
                        /\ allReady' = FALSE
                        /\ processReady' = 0
                        /\ pc' = [pc EXCEPT !["master"] = "IncUpdatedPosition"]
                        /\ UNCHANGED << iter, maxIter, updatedVelocity, 
                                        allVelocitiesUpdated, updatedPosition, 
                                        allPositionsUpdated, 
                                        simulationFinished, body, bodies >>

IncUpdatedPosition == /\ pc["master"] = "IncUpdatedPosition"
                      /\ updatedPosition' = updatedPosition + 1
                      /\ pc' = [pc EXCEPT !["master"] = "UpdatedPos"]
                      /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                      updatedVelocity, allVelocitiesUpdated, 
                                      allPositionsUpdated, simulationFinished, 
                                      body, bodies >>

UpdatedPos == /\ pc["master"] = "UpdatedPos"
              /\ IF updatedPosition = 3
                    THEN /\ allPositionsUpdated' = TRUE
                    ELSE /\ allPositionsUpdated
                         /\ UNCHANGED allPositionsUpdated
              /\ pc' = [pc EXCEPT !["master"] = "ResetVelBarrier"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedVelocity, allVelocitiesUpdated, 
                              updatedPosition, simulationFinished, body, 
                              bodies >>

ResetVelBarrier == /\ pc["master"] = "ResetVelBarrier"
                   /\ allVelocitiesUpdated' = FALSE
                   /\ updatedVelocity' = 0
                   /\ pc' = [pc EXCEPT !["master"] = "NewIter"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   updatedPosition, allPositionsUpdated, 
                                   simulationFinished, body, bodies >>

NewIter == /\ pc["master"] = "NewIter"
           /\ iter' = iter + 1
           /\ pc' = [pc EXCEPT !["master"] = "MainLoopMaster"]
           /\ UNCHANGED << maxIter, processReady, allReady, updatedVelocity, 
                           allVelocitiesUpdated, updatedPosition, 
                           allPositionsUpdated, simulationFinished, body, 
                           bodies >>

Master == MainLoopMaster \/ IncReadyToStart \/ ReadyToStart
             \/ ResetPosBarrier \/ IncUpdatedVelocity \/ UpdatedVel
             \/ ResetAllReadyBarrier \/ IncUpdatedPosition \/ UpdatedPos
             \/ ResetVelBarrier \/ NewIter

MainLoopW1 == /\ pc["worker1"] = "MainLoopW1"
              /\ IF iter < maxIter
                    THEN /\ pc' = [pc EXCEPT !["worker1"] = "IncReadyToStartW1"]
                    ELSE /\ pc' = [pc EXCEPT !["worker1"] = "Done"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedVelocity, allVelocitiesUpdated, 
                              updatedPosition, allPositionsUpdated, 
                              simulationFinished, body, bodies >>

IncReadyToStartW1 == /\ pc["worker1"] = "IncReadyToStartW1"
                     /\ processReady' = processReady + 1
                     /\ pc' = [pc EXCEPT !["worker1"] = "ReadyToStartW1"]
                     /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                     allVelocitiesUpdated, updatedPosition, 
                                     allPositionsUpdated, simulationFinished, 
                                     body, bodies >>

ReadyToStartW1 == /\ pc["worker1"] = "ReadyToStartW1"
                  /\ IF processReady = 3
                        THEN /\ allReady' = TRUE
                        ELSE /\ allReady
                             /\ UNCHANGED allReady
                  /\ pc' = [pc EXCEPT !["worker1"] = "UpdVelB1"]
                  /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                  allVelocitiesUpdated, updatedPosition, 
                                  allPositionsUpdated, simulationFinished, 
                                  body, bodies >>

UpdVelB1 == /\ pc["worker1"] = "UpdVelB1"
            /\ bodies' = [bodies EXCEPT ![1].vel = bodies[1].vel + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdVelB2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

UpdVelB2 == /\ pc["worker1"] = "UpdVelB2"
            /\ bodies' = [bodies EXCEPT ![2].vel = bodies[2].vel + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "IncUpdatedVelw1"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

IncUpdatedVelw1 == /\ pc["worker1"] = "IncUpdatedVelw1"
                   /\ updatedVelocity' = updatedVelocity + 1
                   /\ pc' = [pc EXCEPT !["worker1"] = "UpdatedVelW1"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   allVelocitiesUpdated, updatedPosition, 
                                   allPositionsUpdated, simulationFinished, 
                                   body, bodies >>

UpdatedVelW1 == /\ pc["worker1"] = "UpdatedVelW1"
                /\ IF updatedVelocity = 3
                      THEN /\ allVelocitiesUpdated' = TRUE
                      ELSE /\ allVelocitiesUpdated
                           /\ UNCHANGED allVelocitiesUpdated
                /\ pc' = [pc EXCEPT !["worker1"] = "UpdPosB1"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, updatedPosition, 
                                allPositionsUpdated, simulationFinished, body, 
                                bodies >>

UpdPosB1 == /\ pc["worker1"] = "UpdPosB1"
            /\ bodies' = [bodies EXCEPT ![1].pos = bodies[1].pos + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "UpdPosB2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

UpdPosB2 == /\ pc["worker1"] = "UpdPosB2"
            /\ bodies' = [bodies EXCEPT ![2].pos = bodies[2].pos + 1]
            /\ pc' = [pc EXCEPT !["worker1"] = "IncUpdatedPosW1"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

IncUpdatedPosW1 == /\ pc["worker1"] = "IncUpdatedPosW1"
                   /\ updatedPosition' = updatedPosition + 1
                   /\ pc' = [pc EXCEPT !["worker1"] = "UpdatedPosW1"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   updatedVelocity, allVelocitiesUpdated, 
                                   allPositionsUpdated, simulationFinished, 
                                   body, bodies >>

UpdatedPosW1 == /\ pc["worker1"] = "UpdatedPosW1"
                /\ IF updatedPosition = 3
                      THEN /\ allPositionsUpdated' = TRUE
                      ELSE /\ allPositionsUpdated
                           /\ UNCHANGED allPositionsUpdated
                /\ pc' = [pc EXCEPT !["worker1"] = "MainLoopW1"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, allVelocitiesUpdated, 
                                updatedPosition, simulationFinished, body, 
                                bodies >>

Worker1 == MainLoopW1 \/ IncReadyToStartW1 \/ ReadyToStartW1 \/ UpdVelB1
              \/ UpdVelB2 \/ IncUpdatedVelw1 \/ UpdatedVelW1 \/ UpdPosB1
              \/ UpdPosB2 \/ IncUpdatedPosW1 \/ UpdatedPosW1

MainLoopW2 == /\ pc["worker2"] = "MainLoopW2"
              /\ IF iter < maxIter
                    THEN /\ pc' = [pc EXCEPT !["worker2"] = "IncReadyToStartW2"]
                    ELSE /\ pc' = [pc EXCEPT !["worker2"] = "Done"]
              /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                              updatedVelocity, allVelocitiesUpdated, 
                              updatedPosition, allPositionsUpdated, 
                              simulationFinished, body, bodies >>

IncReadyToStartW2 == /\ pc["worker2"] = "IncReadyToStartW2"
                     /\ processReady' = processReady + 1
                     /\ pc' = [pc EXCEPT !["worker2"] = "ReadyToStartW2"]
                     /\ UNCHANGED << iter, maxIter, allReady, updatedVelocity, 
                                     allVelocitiesUpdated, updatedPosition, 
                                     allPositionsUpdated, simulationFinished, 
                                     body, bodies >>

ReadyToStartW2 == /\ pc["worker2"] = "ReadyToStartW2"
                  /\ IF processReady = 3
                        THEN /\ allReady' = TRUE
                        ELSE /\ allReady
                             /\ UNCHANGED allReady
                  /\ pc' = [pc EXCEPT !["worker2"] = "UpdVelB3"]
                  /\ UNCHANGED << iter, maxIter, processReady, updatedVelocity, 
                                  allVelocitiesUpdated, updatedPosition, 
                                  allPositionsUpdated, simulationFinished, 
                                  body, bodies >>

UpdVelB3 == /\ pc["worker2"] = "UpdVelB3"
            /\ bodies' = [bodies EXCEPT ![3].vel = bodies[3].vel + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdVelB4"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

UpdVelB4 == /\ pc["worker2"] = "UpdVelB4"
            /\ bodies' = [bodies EXCEPT ![4].vel = bodies[4].vel + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "IncUpdatedVelw2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

IncUpdatedVelw2 == /\ pc["worker2"] = "IncUpdatedVelw2"
                   /\ updatedVelocity' = updatedVelocity + 1
                   /\ pc' = [pc EXCEPT !["worker2"] = "UpdatedVelW2"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   allVelocitiesUpdated, updatedPosition, 
                                   allPositionsUpdated, simulationFinished, 
                                   body, bodies >>

UpdatedVelW2 == /\ pc["worker2"] = "UpdatedVelW2"
                /\ IF updatedVelocity = 3
                      THEN /\ allVelocitiesUpdated' = TRUE
                      ELSE /\ allVelocitiesUpdated
                           /\ UNCHANGED allVelocitiesUpdated
                /\ pc' = [pc EXCEPT !["worker2"] = "UpdPosB3"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, updatedPosition, 
                                allPositionsUpdated, simulationFinished, body, 
                                bodies >>

UpdPosB3 == /\ pc["worker2"] = "UpdPosB3"
            /\ bodies' = [bodies EXCEPT ![3].pos = bodies[3].pos + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "UpdPosB4"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

UpdPosB4 == /\ pc["worker2"] = "UpdPosB4"
            /\ bodies' = [bodies EXCEPT ![4].pos = bodies[4].pos + 1]
            /\ pc' = [pc EXCEPT !["worker2"] = "IncUpdatedPosW2"]
            /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                            updatedVelocity, allVelocitiesUpdated, 
                            updatedPosition, allPositionsUpdated, 
                            simulationFinished, body >>

IncUpdatedPosW2 == /\ pc["worker2"] = "IncUpdatedPosW2"
                   /\ updatedPosition' = updatedPosition + 1
                   /\ pc' = [pc EXCEPT !["worker2"] = "UpdatedPosW2"]
                   /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                   updatedVelocity, allVelocitiesUpdated, 
                                   allPositionsUpdated, simulationFinished, 
                                   body, bodies >>

UpdatedPosW2 == /\ pc["worker2"] = "UpdatedPosW2"
                /\ IF updatedPosition = 3
                      THEN /\ allPositionsUpdated' = TRUE
                      ELSE /\ allPositionsUpdated
                           /\ UNCHANGED allPositionsUpdated
                /\ pc' = [pc EXCEPT !["worker2"] = "MainLoopW2"]
                /\ UNCHANGED << iter, maxIter, processReady, allReady, 
                                updatedVelocity, allVelocitiesUpdated, 
                                updatedPosition, simulationFinished, body, 
                                bodies >>

Worker2 == MainLoopW2 \/ IncReadyToStartW2 \/ ReadyToStartW2 \/ UpdVelB3
              \/ UpdVelB4 \/ IncUpdatedVelw2 \/ UpdatedVelW2 \/ UpdPosB3
              \/ UpdPosB4 \/ IncUpdatedPosW2 \/ UpdatedPosW2

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
\* Last modified Sat Apr 02 10:03:14 CEST 2022 by davidedomini
\* Created Tue Mar 29 20:19:23 CEST 2022 by davidedomini
