within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces;
partial model PartialSecondaryPumpGroup
  extends Fluid.Interfaces.PartialTwoPort(
    redeclare replaceable package Medium=Buildings.Media.Water);

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup
    typ "Type of chilled water secondary pump group"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  outer parameter Integer nChi "Number of chillers in group";
  outer parameter Integer nPumPri "Number of primary pumps";
  parameter Integer nPum = 2 "Number of secondary pumps";

  parameter Modelica.Units.SI.MassFlowRate mTot_flow_nominal = m_flow_nominal*nPum "Total mass flow rate for pump group";

  // FixMe: Flow and dp should be read from pump curve, but are currently
  // assumed from system flow rate and pressure drop.
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = mTot_flow_nominal/nPum
    "Nominal mass flow rate per pump";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure drop per pump";

  final parameter Boolean is_none=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup.None;

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi,
    final nPumPri=nPumPri,
    final nPumSec=nPum) if not is_none
             "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
              Icon(graphics={
              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialSecondaryPumpGroup;
