within Buildings.Fluid.Storage.PCM.Validation;
model charging58
  extends ChargingDischarging(
    pcmFourPort(redeclare Buildings.Fluid.Storage.PCM.Data.HeatExchanger.Q3
        Design, redeclare
        Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial.PCM58 Material,
      pcm_new=true,
      redeclare package pcm_data = slPCMlib.Media_Rubitherm_RT.Rubitherm_RT60),
    HPCdata(fileName=
          "C:/drive/pcm/PCM-Validation/58_pcm_single_all_runs/58_single_3lpm_30C_65C_Run1_all.txt"),
    LPCdata(fileName=
          "C:/drive/pcm/PCM-Validation/58_pcm_single_all_runs/58_single_3lpm_30C_65C_Run1_all.txt"));

  annotation (experiment(
      StopTime=33000,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"));
end charging58;
