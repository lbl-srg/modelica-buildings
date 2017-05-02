within Buildings.Experimental.ScalableModels.ScalableDemo;
model MultizoneWithVAV
  extends Modelica.Icons.Example;
  HVACSystems.VAVBranch vAVBranch
    annotation (Placement(transformation(extent={{52,8},{82,38}})));
  ThermalZones.BaseClasses.MultiZoneFluctuatingIHG multiZoneFluctuatingIHG
    annotation (Placement(transformation(extent={{48,54},{88,94}})));
  Fluid.Movers.FlowControlled_dp fan
    annotation (Placement(transformation(extent={{-16,-46},{4,-26}})));
  Fluid.HeatExchangers.DryEffectivenessNTU hex
    annotation (Placement(transformation(extent={{-82,-48},{-62,-28}})));
  Fluid.HeatExchangers.WetCoilCounterFlow cooCoi
    annotation (Placement(transformation(extent={{-48,-48},{-28,-28}})));
  Fluid.FixedResistances.PressureDrop res
    annotation (Placement(transformation(extent={{-116,-42},{-96,-22}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -120},{120,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{120,
            140}})));
end MultizoneWithVAV;
