within Buildings.Fluid.Storage.PCM.Examples;
model material_test0

  BaseClasses.partialUnitCellPhaseChangeTwoCircuit
    partialUnitCellPhaseChangeTwoCircuit(redeclare
      Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial.PCM58_a Material,
      TStart_pcm=288.15)
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end material_test0;
