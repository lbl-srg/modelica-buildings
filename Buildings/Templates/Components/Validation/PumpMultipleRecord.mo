within Buildings.Templates.Components.Validation;
model PumpMultipleRecord "Test model for parameter propagation with the multiple-pump record"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Fluid medium";

  parameter Integer nPum(
    final min=0,
    start=1)=2
    "Number of pumps"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nPum](
    each start=1,
    each final min=0)={1, 2}
    "Mass flow rate - Each pump";
  final parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal[nPum]=
    m_flow_nominal ./ datDef.rho_default
    "Mass flow rate - Each pump";
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nPum](
    each start=0,
    each final min=0)={1, 2} .* 1E4
    "Total pressure rise - Each pump";

  parameter Buildings.Templates.Components.Data.PumpMultiple datDef(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nPum,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal)
    "Parameter record - Default bindings for subrecord per"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  parameter Buildings.Templates.Components.Data.PumpMultiple datRed(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nPum,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos80slash1to12 per)
    "Parameter record - Redeclaration of subrecord per"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  parameter Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos80slash1to12 per1;
  parameter Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos50slash1to12 per2;

  parameter Buildings.Templates.Components.Data.PumpMultiple datAss(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nPum,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    per={per1, per2})
    "Parameter record - Assignment of subrecord per"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  parameter Buildings.Templates.Components.Data.PumpMultiple datPre(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nPum,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    per(pressure(
      V_flow={{0, 2, 4} * m_flow_nominal[i] / datPre.rho_default for i in 1:nPum},
      dp={{2, 1.5, 0.8} * dp_nominal[i] for i in 1:nPum})))
    "Parameter record - Assignment of pressure inside the subrecord per"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  annotation (
  experiment(
    StopTime=1,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/PumpMultipleRecord.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the parameter propagation within the record class
<a href=\"modelica://Buildings.Templates.Components.Data.PumpMultiple\">
Buildings.Templates.Components.Data.PumpMultiple</a>.
</p>
<p>
The instance <code>datDef</code> illustrates the default pressure curve
assignment based on the design parameters.
</p>
<p>
The instance <code>datRed</code> illustrates the modification of the 
pressure curve by redeclaring the subrecord <code>per</code>.
In this case, all elements <code>per[i]</code> are equal.
</p>
<p>
The instances <code>datAss</code> and <code>datPre</code> illustrate
the modification of the pressure curve by assigning either the whole 
subrecord <code>per</code> or its component <code>per.pressure</code>.
This allows assigning different pressure curves to the elements <code>per[i]</code>.
</p>
</html>"));
end PumpMultipleRecord;
