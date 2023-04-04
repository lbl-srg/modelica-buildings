within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
package BaseClasses
  extends Modelica.Icons.BasesPackage;

  block PLRToPulse
    "Converts an input for part load ratio value into an enable signal"

    parameter Real tPer = 15*60
      "Timestep period for PLR sampling";

    Buildings.Controls.OBC.CDL.Interfaces.RealInput uPLR
      "Part load ratio input"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEna
      "Component enable signal"
      annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  protected
    Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
      final k=tPer)
      "Calculate runtime from PLR signal"
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));

    Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
      "Sample the part load ratio signal"
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

    Buildings.Controls.OBC.CDL.Logical.Timer tim
      "Check component runtime"
      annotation (Placement(transformation(extent={{-20,30},{0,50}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      final width=1e-6/tPer,
      final period=tPer)
      "Outputs true signals for 1e-6 second duration at required timestep interval"
      annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

    Buildings.Controls.OBC.CDL.Continuous.Less les
      "Check if component runtime has exceeded required runtime from PLR"
      annotation (Placement(transformation(extent={{20,40},{40,60}})));

    Buildings.Controls.OBC.CDL.Logical.Latch lat
      "Output a true signal from start of currrent timestep, until the required run-time is achieved"
      annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

    Buildings.Controls.OBC.CDL.Logical.Pre pre
      "Pre block for looping back latch reset signal"
      annotation (Placement(transformation(extent={{50,20},{70,40}})));

    Buildings.Controls.OBC.CDL.Logical.And andRes
      "Lets true signal pass only when latch is not being reset"
      annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

    Buildings.Controls.OBC.CDL.Logical.Not notRes
      "Check if the latch signal is being reset"
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

    Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=1e-6)
      "Delay the enable sugnal by 1e-6 seconds, which is also the duration for 
    which the pulse signal is held. Required when PLR input is zero"
      annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  equation
    connect(triSam.y, gai.u)
      annotation (Line(points={{-38,70},{-22,70}}, color={0,0,127}));
    connect(uPLR, triSam.u)
      annotation (Line(points={{-120,0},{-90,0},{-90,70},{-62,70}},color={0,0,127}));
    connect(gai.y, les.u1)
      annotation (Line(points={{2,70},{14,70},{14,50},{18,50}}, color={0,0,127}));
    connect(tim.y, les.u2)
      annotation (Line(points={{2,40},{10,40},{10,42},{18,42}}, color={0,0,127}));
    connect(lat.y, tim.u)
      annotation (Line(points={{-28,40},{-22,40}}, color={255,0,255}));
    connect(les.y, pre.u)
      annotation (Line(points={{42,50},{46,50},{46,30},{48,30}}, color={255,0,255}));                                                                                                                          connect(pre.y, lat.clr) annotation (Line(points={{72,30},{76,30},{76,10},{-60,          10},{-60,34},{-52,34}}, color={255,0,255}));
    connect(booPul.y, andRes.u1)
      annotation (Line(points={{-38,-40},{-22,-40}}, color={255,0,255}));
    connect(andRes.y, triSam.trigger)
      annotation (Line(points={{2,-40},{10,-40},{10,-20},{-70,-20},{-70,54},{-50,54},{-50,58}},
        color={255,0,255}));
    connect(andRes.y, lat.u)
      annotation (Line(points={{2,-40},{10,-40},{10,-20},{-70,-20},{-70,40},{-52,40}},
        color={255,0,255}));
    connect(notRes.y, andRes.u2)
      annotation (Line(points={{-38,-70},{-30,-70},{-30,-48},{-22,-48}},
        color={255,0,255}));
    connect(pre.y, notRes.u)
      annotation (Line(points={{72,30},{76,30},{76,-90},{-70,-90},{-70,-70},{-62,-70}},
        color={255,0,255}));
    connect(lat.y, truDel.u)
      annotation (Line(points={{-28,40},{-26,40},{-26,-10},{38,-10}},
        color={255,0,255}));
    connect(truDel.y, yEna)
      annotation (Line(points={{62,-10},{92,-10},{92,0},{120,0}},
        color={255,0,255}));

  annotation (Icon(
      coordinateSystem(preserveAspectRatio=false),
      graphics={Rectangle(extent={{-100,100},{100,-100}},lineColor={0,0,0},
        fillColor={255,255,255},fillPattern = FillPattern.Solid),
                                          Text(
          extent={{-160,140},{160,100}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(defaultComponentName="plrToPul",
    coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block calculates the time duration for which the DX coil needs to be kept on
based on the part-load ratio input signal <code>uPLR</code> for the timestep 
<code>tPer</code>, and then generates an output enable signal <code>yEna</code> 
for that duration. Once the component has been kept enabled for the calculated 
duration, the component is disabled.
</p>
</html>",
  revisions="<html>
<ul>
<li>
April 03, 2023 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PLRToPulse;

  package Validation
    "Package with validation models for baseclasses"
    extends Modelica.Icons.ExamplesPackage;
    model PLRToPulse
      "Validation model for the PLRToPulse block"
      extends Modelica.Icons.Example;

      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation.BaseClasses.PLRToPulse
        plrToPul
        "Instance of the PLR converter to validate"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      Buildings.Controls.OBC.CDL.Logical.Timer timEna
        "Time for which the enable signal is true"
        annotation (Placement(transformation(extent={{40,-10},{60,10}})));

      Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gaiTim(
        final k=15*60)
        "Calculate time for which component needs to be enabled"
        annotation (Placement(transformation(extent={{40,30},{60,50}})));

    protected
      Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plr(
        final height=1,
        final duration(displayUnit="min")= 15*5*60)
        "Part-load ratio signal"
        annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

      Buildings.Controls.OBC.CDL.Discrete.Sampler samPLR(
        final samplePeriod(displayUnit="min") = 900)
        "Sample the PLR every timestep"
        annotation (Placement(transformation(extent={{-10,30},{10,50}})));

    equation
      connect(plr.y,plrToPul. uPLR)
        annotation (Line(points={{-28,0},{-12,0}}, color={0,0,127}));
      connect(plrToPul.yEna, timEna.u)
        annotation (Line(points={{12,0},{38,0}}, color={255,0,255}));
      connect(plr.y, samPLR.u) annotation (Line(points={{-28,0},{-20,0},{-20,40},{-12,
              40}}, color={0,0,127}));
      connect(samPLR.y, gaiTim.u)
        annotation (Line(points={{12,40},{38,40}}, color={0,0,127}));
      annotation (Documentation(preferredView="info", info="<html>
<p>
This model validates the PLR to pulse converter by providing it a time-varying 
input signal for the part-load ratio, and then comparing the enabled time results 
against required calculated values.
</p>
</html>"),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Validation/Baseclasses/Validation/PLRToPulse.mos"
            "Simulate and plot"));
    end PLRToPulse;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models for the classes in the baseclasses package.
</p>
</html>"));
  end Validation;
  annotation (preferredView="info", Documentation(info="<html>
  This package contains base classes that are used in the validation models.
  </html>"));
end BaseClasses;
