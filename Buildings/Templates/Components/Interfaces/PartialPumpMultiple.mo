within Buildings.Templates.Components.Interfaces;
partial model PartialPumpMultiple
  "Interface class for multiple pumps in parallel arrangement"
  extends Buildings.Templates.Components.Interfaces.PartialPump;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation(__Linkage(enable=false));

  parameter Integer nPum(
    final min=0,
    start=1)
    "Number of pumps"
    annotation (Dialog(group="Configuration",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  parameter Buildings.Templates.Components.Data.PumpMultiple dat(
    final nPum=nPum,
    final typ=typ)
    "Design and operating parameters"
    annotation(__Linkage(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nPum](
    each final min=0)=dat.m_flow_nominal
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  final parameter Modelica.Units.SI.PressureDifference dp_nominal[nPum](
    each final min=0,
    each displayUnit="Pa")=dat.dp_nominal
    "Pump head at design conditions"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default))
     "Vectorized fluid connector a (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{-110,-40},{-90,40}}), iconTransformation(extent={{-110,
            -40},{-90,40}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default))
     "Vectorized fluid connector b (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{90,-40},{110,40}}), iconTransformation(extent={{90,-40},
            {110,40}})));

  parameter Integer icon_dy = 250
    "Distance in y-direction between each unit in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for models
of multiple pumps in parallel arrangement.
Note that the inlet and outlet manifolds are not included
in this model. This way, the same interface can be used to model
both headered pumps and dedicated pumps.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
    Line(
      visible=nPum>=2,
      points={{-100,icon_dy},{100,icon_dy}},
      color={0,0,0},
      thickness=1),
    Line(
      points={{-100,0},{100,0}},
      color={0,0,0},
      thickness=1),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None,
        extent={{-100,-70},{0,30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe,
        extent={{26,-22},{100,28}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=2,
        extent={{-100,icon_dy-70},{0,icon_dy+30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe and nPum>=2,
        extent={{26,icon_dy-22},{100,icon_dy+28}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None,
          points={{-50,60},{-50,22}},
          color={0,0,0},
          thickness=0.5),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var,
        extent={{-100,60},{0,160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None,
          points={{-50,310},{-50,272}},
          color={0,0,0},
          thickness=0.5),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var,
        extent={{-100,310},{0,410}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg")}));
end PartialPumpMultiple;
