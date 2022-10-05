within Buildings.Fluid.Storage.Ice.Examples.BaseClasses.Validation;
model ControlDemandLevel
  "Model that validates the controller that outputs the demand level"
  extends Modelica.Icons.Example;


  Buildings.Fluid.Storage.Ice.Examples.BaseClasses.ControlDemandLevel conDemLev(
    k=1,
    Ti=30)
    "Controller for demand level"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter UA(k=20)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Controls.OBC.CDL.Continuous.Subtract dT
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Controls.OBC.CDL.Continuous.Add           dTdt "Temperature derivative"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter Q1(k=-300)
    "Heat injection for first stage"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    amplitude=10,
    freqHz=1/86400,
    phase=3.1415926535898,
    offset=16 + 273.15,
    startTime(displayUnit="d") = -172800)
    "Outdoor dry bulb temperature to test heating system"
    annotation (Placement(transformation(extent={{-92,50},{-72,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSet(k=6 + 273.15) "Set point"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter Q2(k=-300)
    "Heat injection for second stage"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Continuous.Integrator TMea(
    k=0.000005,
    y_start=6 + 273.15,
    y(final unit="K", displayUnit="degC")) "Measured fluid temperature"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Controls.OBC.CDL.Continuous.Add Q_flow "Total heat injection"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(dT.y,UA.u)
    annotation (Line(points={{-38,40},{-32,40}},  color={0,0,127}));
  connect(dTdt.y,TMea.u)
    annotation (Line(points={{22,30},{38,30}},  color={0,0,127}));
  connect(UA.y,dTdt.u1)
    annotation (Line(points={{-8,40},{-6,40},{-6,36},{-2,36}},    color={0,0,127}));
  connect(TOut.y,dT. u1) annotation (Line(points={{-70,60},{-68,60},{-68,46},{
          -62,46}},   color={0,0,127}));
  connect(TMea.y,dT. u2) annotation (Line(points={{61,30},{80,30},{80,-66},{-52,
          -66},{-52,-36},{-84,-36},{-84,34},{-62,34}},
                                   color={0,0,127}));
  connect(Q1.y, Q_flow.u1) annotation (Line(points={{22,-10},{32,-10},{32,-24},{
          38,-24}}, color={0,0,127}));
  connect(Q2.y, Q_flow.u2) annotation (Line(points={{22,-50},{30,-50},{30,-36},
          {38,-36}},color={0,0,127}));
  connect(Q_flow.y, dTdt.u2) annotation (Line(points={{62,-30},{68,-30},{68,10},
          {-8,10},{-8,24},{-2,24}}, color={0,0,127}));
  connect(conDemLev.yDemLev1, Q1.u) annotation (Line(points={{-18,-30},{-8,-30},
          {-8,-10},{-2,-10}}, color={0,0,127}));
  connect(conDemLev.yDemLev2, Q2.u) annotation (Line(points={{-18,-36},{-12,-36},
          {-12,-50},{-2,-50}}, color={0,0,127}));
  connect(conDemLev.u_s, TSet.y) annotation (Line(points={{-42,-25},{-52,-25},{-52,
          -20},{-58,-20}}, color={0,0,127}));
  connect(TMea.y,conDemLev. u_m) annotation (Line(points={{61,30},{80,30},{80,-66},
          {-52,-66},{-52,-35},{-42,-35}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/BaseClasses/Validation/ControlDemandLevel.mos"
        "Simulate and Plot"),
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-154,152},{146,112}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{52,14},{96,-12}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=1)))}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model that validates the demand level controller.
Input to the controller is a set point and a time varying measured temperature,
which should switch the output across the different levels.
Based on the demand level, heat is injected into a first order element that emulates the temperature
of the chilled water loop.
Based on the control output of the PI controller, the demand level is switched between off, normal demand
and elevated demand.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlDemandLevel;
