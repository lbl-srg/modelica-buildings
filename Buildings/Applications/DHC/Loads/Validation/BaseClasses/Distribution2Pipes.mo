within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Distribution2Pipes
  extends DHC.Examples.FifthGeneration.Unidirectional.Networks.UnidirectionalParallel(
    redeclare DHC.Examples.FifthGeneration.Unidirectional.Networks.BaseClasses.ConnectionParallel
      con[nCon](redeclare Fluid.FixedResistances.PressureDrop pipDisSup(
        redeclare each package Medium=Medium,
        m_flow_nominal=mDis_flow_nominal,
        dp_nominal=dpDis_nominal,
        each allowFlowReversal=allowFlowReversal)));
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[nCon];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end Distribution2Pipes;
