within Buildings.Utilities.Plotters.Examples;
model SingleZoneVAVSupply_u
  "Scatter plots for control signal of a single zone VAV controller from ASHRAE Guideline 36"
  extends
    Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.Validation.VAVSupply_u;
  inner Configuration plotConfiguration(samplePeriod=0.005) "Plot configuration"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Controls.OBC.CDL.Continuous.Add heaCooConSig(k1=-1)
    "Room control signal for heating (negative) and cooling"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Utilities.Plotters.Scatter scaTem(
    title="Temperature setpoints",
    n=2,
    xlabel="Heating (negative) and cooling (positive) control loop signal",
    legend={"THea [degC]","TCoo [degC]"},
    introduction="Set point temperatures as a function of the heating loop signal (from -1 to 0) and
the cooling loop signal (from 0 to +1).")
         "Scatter plot for temperature setpoints"
    annotation (Placement(transformation(extent={{110,10},{130,30}})));
  Modelica.Blocks.Math.UnitConversions.To_degC THea_degC
    "Control signal for heating"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Math.UnitConversions.To_degC TCoo_degC1
    "Control signal for cooling"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Utilities.Plotters.Scatter scaYFan(
    n=1,
    title="Fan control signal",
    legend={"yFan"},
    xlabel="Heating (negative) and cooling (positive) control loop signal",
    introduction="Fan speed as a function of the heating loop signal (from -1 to 0) and
the cooling loop signal (from 0 to +1).
What appears to be a slight overshoot is due to the hysteresis that is used to avoid a hard switch between the different control regimes.")
                     "Scatter plot for fan speed"
    annotation (Placement(transformation(extent={{108,-40},{128,-20}})));
equation
  connect(uHea.y, heaCooConSig.u1) annotation (Line(points={{-59,80},{-12,80},{-12,
          -64},{58,-64}}, color={0,0,127}));
  connect(uCoo.y, heaCooConSig.u2) annotation (Line(points={{-59,50},{-16,50},{-16,
          -76},{58,-76}}, color={0,0,127}));
  connect(scaTem.x, heaCooConSig.y) annotation (Line(points={{108,12},{100,12},{
          100,-70},{81,-70}}, color={0,0,127}));
  connect(setPoiVAV.THeaEco, THea_degC.u)
    annotation (Line(points={{21,6},{48,6},{48,30},{58,30}}, color={0,0,127}));
  connect(setPoiVAV.TCoo, TCoo_degC1.u)
    annotation (Line(points={{21,0},{58,0}},        color={0,0,127}));
  connect(THea_degC.y, scaTem.y[1]) annotation (Line(points={{81,30},{88,30},{88,
          21},{108,21}},color={0,0,127}));
  connect(TCoo_degC1.y, scaTem.y[2])
    annotation (Line(points={{81,0},{88,0},{88,19},{108,19}},color={0,0,127}));
  connect(setPoiVAV.y, scaYFan.y[1]) annotation (Line(points={{21,-6},{48,-6},{48,
          -30},{106,-30}}, color={0,0,127}));
  connect(heaCooConSig.y, scaYFan.x) annotation (Line(points={{81,-70},{100,-70},
          {100,-38},{106,-38}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{140,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/SingleZoneVAVSupply_u.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
This example demonstrates how to create a scatter plot that shows
for a single zone VAV control logic
the heating and cooling set point temperatures, and the fan speed,
all as a function of the heating and cooling control signal.
The plot will be generated in the file <code>plots.html</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleZoneVAVSupply_u;
