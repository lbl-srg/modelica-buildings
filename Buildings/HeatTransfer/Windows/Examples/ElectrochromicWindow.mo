within Buildings.HeatTransfer.Windows.Examples;
model ElectrochromicWindow "Electrochromic window"
  extends Window(
    redeclare Data.GlazingSystems.DoubleElectrochromicAir13Clear glaSys,
      uSha(
        height=0,
        duration=0,
        startTime=0));
  Modelica.Blocks.Sources.Ramp uWin(duration=0.5, startTime=0.25)
    "Window control signal"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(uWin.y, winRad.uSta) annotation (Line(points={{-59,-70},{-18,-70},{
          114.8,-70},{114.8,-21.6}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{340,200}})),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/ElectrochromicWindow.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
This model demonstrates the implementation of a window model.
On the left hand side is a model for the combined convective and radiative heat
transfer on the outside facing side of the window.
In the top middle is the window model, and below is a model that
computes the solar radiation balance of the window. Output of the solar
radiation balance model are the absorbed solar heat flow rates, which are
input to the heat balance models.
On the right hand side are models for the inside surface heat balance.
As opposed to the outside surface heat balance models, these models are
implemented using separate components for the radiative balance and for the convective
balance. This has been done to allow separating radiation from convection,
which is required when the room model is used with room air heat balance models
that use computational fluid dynamics.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 7, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectrochromicWindow;
