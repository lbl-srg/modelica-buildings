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

  parameter Integer icon_dy = 300
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
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
    Text(
      extent={{-149,-114},{151,-154}},
      textColor={0,0,255},
      textString="%name"),
    Line( visible=typ <> Buildings.Templates.Components.Types.Pump.None and
              nPum >= 2,
          points={{-100,icon_dy},{100,icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=2,
          points={{-50,icon_dy+60},{-50,icon_dy+22}},
          color={0,0,0}),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=2,
        extent={{-100,icon_dy-70},{0,icon_dy+30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe and nPum>=2,
        extent={{20,icon_dy-40},{100,icon_dy+40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_var and nPum>=2,
        extent={{-100,icon_dy+60},{0,icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var and nPum>=2,
        extent={{-100,icon_dy+60},{0,icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=3,
      points={{-100,2*icon_dy},{100,2*icon_dy}},
      color={0,0,0},
      thickness=5),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=3,
          points={{-50,2*icon_dy+60},{-50,2*icon_dy+22}},
          color={0,0,0}),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=3,
        extent={{-100,2*icon_dy-70},{0,2*icon_dy+30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe and nPum>=3,
        extent={{20, 2*icon_dy-40},{100, 2*icon_dy+40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_var and nPum>=3,
        extent={{-100, 2*icon_dy+60},{0, 2*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var and nPum>=3,
        extent={{-100, 2*icon_dy+60},{0, 2*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=4,
      points={{-100, 3*icon_dy},{100, 3*icon_dy}},
      color={0,0,0},
      thickness=5),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=4,
          points={{-50, 3*icon_dy+60},{-50, 3*icon_dy+22}},
          color={0,0,0}),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=4,
        extent={{-100, 3*icon_dy-70},{0, 3*icon_dy+30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe and nPum>=4,
        extent={{20, 3*icon_dy-40},{100, 3*icon_dy+40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_var and nPum>=4,
        extent={{-100, 3*icon_dy+60},{0, 3*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var and nPum>=4,
        extent={{-100, 3*icon_dy+60},{0, 3*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=5,
      points={{-100, 4*icon_dy},{100, 4*icon_dy}},
      color={0,0,0},
      thickness=5),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=5,
          points={{-50, 4*icon_dy+60},{-50, 4*icon_dy+22}},
          color={0,0,0}),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=5,
        extent={{-100, 4*icon_dy-70},{0, 4*icon_dy+30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe and nPum>=5,
        extent={{20, 4*icon_dy-40},{100, 4*icon_dy+40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_var and nPum>=5,
        extent={{-100, 4*icon_dy+60},{0, 4*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var and nPum>=5,
        extent={{-100, 4*icon_dy+60},{0, 4*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=6,
      points={{-100, 5*icon_dy},{100, 5*icon_dy}},
      color={0,0,0},
      thickness=5),
    Line( visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=6,
          points={{-50, 5*icon_dy+60},{-50, 5*icon_dy+22}},
          color={0,0,0}),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and nPum>=6,
        extent={{-100, 5*icon_dy-70},{0, 5*icon_dy+30}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_valChe and nPum>=6,
        extent={{20, 5*icon_dy-40},{100, 5*icon_dy+40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_var and nPum>=6,
        extent={{-100, 5*icon_dy+60},{0, 5*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var and nPum>=6,
        extent={{-100, 5*icon_dy+60},{0, 5*icon_dy+160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg")
}));

end PartialPumpMultiple;
