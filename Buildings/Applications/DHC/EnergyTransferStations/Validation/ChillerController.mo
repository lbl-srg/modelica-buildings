within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model ChillerController "Chiller controller validation"

  Control.ChillerController chiCon
  "EIR chiller controller"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Sources.BooleanPulse heaMod(
    width=50,
    period=1000)
    "Step control"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.BooleanPulse cooMod(
    width=50,
    period=500,
    startTime=500)
    "Step control"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BaseClasses.Constants cons(
    k={7 + 273.15,40 + 273.15,4 + 273.15,25 + 273.15,18 + 273.15,12 + 273.15,30
         + 273.15,25 + 273.15},
    conNam={"TSetCoo","TSetHea","TCooSetMin","TMinConEnt","TMaxEvaEnt",
        "TEvaEnt","TConLvg","TConEnt"},
    nCon=8)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(chiCon.reqHea, heaMod.y) annotation (Line(points={{38.6,-21},{6,-21},
          {6,30},{-19,30}},
                        color={255,0,255}));
  connect(chiCon.reqCoo, cooMod.y) annotation (Line(points={{38.6,-24.6},{-2,
          -24.6},{-2,0},{-19,0}},
                            color={255,0,255}));
  connect(cons.y[1], chiCon.TSetCoo) annotation (Line(points={{-19,-30.875},{
          -16,-30.875},{-16,-27},{39,-27}},
                                    color={0,0,127}));
  connect(chiCon.TSetHea, cons.y[2]) annotation (Line(points={{39,-29},{-16,-29},
          {-16,-30.625},{-19,-30.625}},
                                color={0,0,127}));
  connect(cons.y[3], chiCon.TSetCooMin) annotation (Line(points={{-19,-30.375},
          {38,-30.375},{38,-31.2},{39,-31.2}},
                                       color={0,0,127}));
  connect(cons.y[5], chiCon.TMaxEvaEnt) annotation (Line(points={{-19,-29.875},
          {-16,-29.875},{-16,-34.6},{39,-34.6}},
                                        color={0,0,127}));
  connect(cons.y[6], chiCon.TEvaEnt) annotation (Line(points={{-19,-29.625},{
          -16,-29.625},{-16,-36.6},{39,-36.6}},
                                        color={0,0,127}));
  connect(cons.y[7], chiCon.TConLvg) annotation (Line(points={{-19,-29.375},{
          -16,-29.375},{-16,-38.4},{39,-38.4}},
                                        color={0,0,127}));
  connect(cons.y[4], chiCon.TMinConEnt) annotation (Line(points={{-19,-30.125},
          {-16,-30.125},{-16,-32.8},{39,-32.8}},
                                        color={0,0,127}));
  connect(cons.y[8], chiCon.TConEnt) annotation (Line(points={{-19,-29.125},{
          -16,-29.125},{-16,-39.8},{39,-39.8}}, color={0,0,127}));

annotation (Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,100}}),
                graphics={Line(points={{-22,22}}, color={28,108,200})}),
       experiment(StopTime=1250,Tolerance=1e-06,__Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Validation/ChillerController.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the controller block
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 20, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerController;
