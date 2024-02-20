within Buildings.Templates.Components.Data;
record PumpMultiple "Record for multiple-pump models"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(
    final min=0,
    start=0)
    "Number of pumps"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nPum](
    each start=1,
    each final min=0)
    "Mass flow rate - Each pump"
    annotation (
    Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nPum](
    each start=0,
    each final min=0)
    "Total pressure rise - Each pump"
    annotation (Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  // To avoid missing support for zero-sized record in case of nPum=0 we use max(nPum, 1).
  replaceable parameter Fluid.Movers.Data.Generic per[max(nPum, 1)](
    pressure(
      V_flow=if typ<>Buildings.Templates.Components.Types.Pump.None then
      {{0, 1, 2} * m_flow_nominal[i] / rho_default for i in 1:nPum} else [0],
      dp=if typ<>Buildings.Templates.Components.Types.Pump.None then
      {{1.14, 1, 0.42} * dp_nominal[i] for i in 1:nPum} else [0]))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data - Each pump"
    annotation(Dialog(enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  parameter Modelica.Units.SI.Density rho_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "Default medium density"
    annotation(Dialog(enable=false));

  annotation (
  defaultComponentName="datPum", Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the multiple-pump model
<a href=\"modelica://Buildings.Templates.Components.Pumps.Multiple\">
Buildings.Templates.Components.Pumps.Multiple</a>.
</p>
<p>
A default flow characteristic is provided, which goes through
the design operating point and spans over
<i>0</i> and twice the design flow rate at maximum speed.
This default characteristic is based on a least squares
polynomial fit of the characteristics from
<a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo\">
Buildings.Fluid.Movers.Data.Pumps.Wilo</a>.
The user may refer to the documentation of 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.UsersGuide.ModelParameters\">
Buildings.Fluid.HydronicConfigurations.UsersGuide.ModelParameters</a>
for further details.
Note that a default medium density is used to parameterize 
the pump characteristic. So models that use this record should
overwrite this default value with the density of the medium
in use, especially in the case of a water/glycol mix. 
</p>
<p>
In order to modify the default characteristic, one may use either
of the following methods.
</p>
<ul>
<li>Assign the whole subrecord <code>per</code> or
only its component <code>per.pressure</code>.
In this case the elements <code>per[i]</code> may differ one from another.
This is the recommended approach for unequally sized units 
such as dedicated pumps.</li>
<li>Redeclare the component <code>per</code>.
In this case the elements <code>per[i]</code> are all equal to the redeclared
record instance.
This is the recommended approach for equally sized units 
such as headered pumps.</li>
</ul>
<p>
Those various use cases are illustrated in
<a href=\"modelica://Buildings.Templates.Components.Validation.PumpMultipleRecord\">
Buildings.Templates.Components.Validation.PumpMultipleRecord</a>.
</p>
</html>"));
end PumpMultiple;
