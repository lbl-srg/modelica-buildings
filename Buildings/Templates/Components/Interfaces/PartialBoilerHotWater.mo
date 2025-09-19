within Buildings.Templates.Components.Interfaces;
partial model PartialBoilerHotWater "Interface class for hot water boiler models"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=mHeaWat_flow_nominal);

  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod
    "Type of boiler model"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Data.BoilerHotWater dat(
    final typMod=typMod)
    "Design and operating parameters";

  parameter Boolean is_con
    "Set to true for condensing boiler, false for non-condensing boiler"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    dat.mHeaWat_flow_nominal
    "HW mass flow rate";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    dat.cap_nominal
    "Heating capacity";
  final parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal=
    dat.dpHeaWat_nominal
    "HW pressure drop";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    dat.THeaWatSup_nominal
    "HW supply temperature";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(transformation(extent={{-20,80},{20,120}}),
     iconTransformation(extent={{-20,80},{20, 120}})));

  replaceable Buildings.Fluid.Boilers.BaseClasses.PartialBoiler boi(
      redeclare final package Medium=Medium,
      final energyDynamics=energyDynamics,
      final allowFlowReversal=allowFlowReversal,
      final show_T=show_T,
      final m_flow_small=m_flow_small)
      "Boiler"
      annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Plants.Controls.Utilities.PIDWithEnable ctlPID
    "HW supply temperature controller"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
initial equation
  if typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Table then
    assert(mHeaWat_flow_nominal <= dat.per.m_flow_nominal,
      "In "+ getInstanceName() + ": " +
      "The design HW flow rate of the boiler model (" +
      String(mHeaWat_flow_nominal) + " kg/s) should be lower than the value from " +
      "the performance data record (" + String(dat.per.m_flow_nominal) + " kg/s)",
      level=AssertionLevel.warning);
    assert(dpHeaWat_nominal >= dat.per.dp_nominal,
      "In "+ getInstanceName() + ": " +
      "The design HW pressure drop of the boiler model (" +
      String(dpHeaWat_nominal) + " Pa) should be higher than the value from " +
      "the performance data record (" + String(dat.per.dp_nominal) + " Pa)",
      level=AssertionLevel.warning);
    assert(cap_nominal <= dat.per.Q_flow_nominal,
      "In "+ getInstanceName() + ": " +
      "The design capacity of the boiler model (" +
      String(cap_nominal) + " W) should be lower than the value from " +
      "the performance data record (" + String(dat.per.Q_flow_nominal) + " W)",
      level=AssertionLevel.warning);
  end if;

equation
  connect(port_a, boi.port_a)
    annotation (Line(points={{-100,0},{-80,0},{-80,-60},{-10,-60}},
                                                color={0,127,255}));
  connect(boi.port_b, port_b)
    annotation (Line(points={{10,-60},{80,-60},{80,0},{100,0}},
                                              color={0,127,255}));
  connect(boi.T, bus.THeaWatSup) annotation (Line(points={{11,-52},{40,-52},{40,
          98},{0,98},{0,100}}, color={0,0,127}));


  connect(ctlPID.y, boi.y) annotation (Line(points={{-28,0},{-20,0},{-20,-52},{
          -12,-52}}, color={0,0,127}));
  connect(boi.T, ctlPID.u_m) annotation (Line(points={{11,-52},{20,-52},{20,-40},
          {-40,-40},{-40,-12}}, color={0,0,127}));
  connect(bus.y1, ctlPID.uEna) annotation (Line(
      points={{0,100},{0,20},{-60,20},{-60,-20},{-44,-20},{-44,-12}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.THeaWatSupSet, ctlPID.u_s) annotation (Line(
      points={{0,100},{0,20},{-60,20},{-60,0},{-52,0}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlPID.y, bus.y_actual) annotation (Line(points={{-28,0},{20,0},{20,
          96},{0,96},{0,100}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for hot water boiler models.
It includes a replaceable instance of
<a href=\"modelica://Buildings.Fluid.Boilers.BaseClasses.PartialBoiler\">
Buildings.Fluid.Boilers.BaseClasses.PartialBoiler</a>.
This model is used to construct the hot water boiler models within
<a href=\"modelica://Buildings.Templates.Components.Boilers\">
Buildings.Templates.Components.Boilers</a>.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Boiler Enable signal <code>y1</code> :
DO signal, with a dimensionality of zero
</li>
<li>
Boiler HW supply temperature setpoint <code>THeaWatSupSet</code>:
AO signal, with a dimensionality of zero
</li>
<li>
Boiler firing rate <code>y_actual</code>:
AI signal, with a dimensionality of zero
</li>
<li>
Boiler HW supply temperature <code>THeaWatSup</code>:
AI signal, with a dimensionality of zero
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
    Rectangle(
          extent={{100,60},{-100,-60}},
          lineColor={0,0,0},
          lineThickness=1),
    Text( extent={{-60,20},{60,-20}},
          textColor={0,0,0},
          textString="BOI"),
    Bitmap(extent={{-20,60},{20,100}}, fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg")}));
end PartialBoilerHotWater;
