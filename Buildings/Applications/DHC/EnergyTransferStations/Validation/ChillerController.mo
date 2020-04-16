within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model ChillerController "Chiller controller validation"
  extends Modelica.Icons.Example;
  FifthGeneration.Controls.Chiller chiCon "EIR chiller controller"
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
  FifthGeneration.BaseClasses.Constants cons(
    k={7 + 273.15,40 + 273.15,4 + 273.15,25 + 273.15,18 + 273.15,12 + 273.15,30
         + 273.15,25 + 273.15},
    conNam={"TSetCoo","TSetHea","TCooSetMin","TMinConEnt","TMaxEvaEnt",
        "TEvaEnt","TConLvg","TConEnt"},
    nCon=8) annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(chiCon.uHea, heaMod.y) annotation (Line(points={{38,-22},{6,-22},{6,
          30},{-19,30}}, color={255,0,255}));
  connect(chiCon.uCoo, cooMod.y) annotation (Line(points={{38,-24},{-2,-24},{-2,
          0},{-19,0}}, color={255,0,255}));
  connect(cons.y[1], chiCon.TChiWatSupSetMax) annotation (Line(points={{-19,
          -30.875},{-16,-30.875},{-16,-28},{38,-28}}, color={0,0,127}));
  connect(chiCon.TConWatLvgSet, cons.y[2]) annotation (Line(points={{38,-27},{-16,
          -27},{-16,-30.625},{-19,-30.625}}, color={0,0,127}));
  connect(cons.y[3], chiCon.TMinEvaWatLvg) annotation (Line(points={{-19,
          -30.375},{38,-30.375},{38,-29},{38,-29}}, color={0,0,127}));
  connect(cons.y[5], chiCon.TMaxEvaWatEnt) annotation (Line(points={{-19,
          -29.875},{-16,-29.875},{-16,-33},{38,-33}}, color={0,0,127}));
  connect(cons.y[6], chiCon.TEvaWatEnt) annotation (Line(points={{-19,-29.625},
          {-16,-29.625},{-16,-32},{38,-32}}, color={0,0,127}));
  connect(cons.y[7], chiCon.TConWatLvg) annotation (Line(points={{-19,-29.375},
          {-16,-29.375},{-16,-37},{38,-37}}, color={0,0,127}));
  connect(cons.y[4], chiCon.TMinConWatEnt) annotation (Line(points={{-19,
          -30.125},{-16,-30.125},{-16,-31},{38,-31}}, color={0,0,127}));
  connect(cons.y[8], chiCon.TConWatEnt) annotation (Line(points={{-19,-29.125},
          {-16,-29.125},{-16,-34},{38,-34}}, color={0,0,127}));

annotation (
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
