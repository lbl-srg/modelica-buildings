within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model AmbientCircuitController "Ambient water circuit controller validation"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanPulse reHeajFulLoa(width=50,
    period=250,
    startTime=375)
    "Reject full surplus heating load"
    annotation (Placement(transformation(extent={{-60,-28},{-40,-8}})));
  Modelica.Blocks.Sources.BooleanConstant valCoo(
    k= false)
    "Status of the two way valve on the chilled water circuit side."
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  BaseClasses.Constants con(
    k={40 + 273.15,20 + 273.15,16 + 273.15,20 + 273.15},
    conNam={"TBorEntMax","TDisHexEnt","TDisHexLvg","TBorLvg"},
    nCon=4)
    "Multiple constant functions"
    annotation (Placement(transformation(extent={{-20,-28},{0,-8}})));
  Modelica.Blocks.Sources.Pulse TBorEnt(
    amplitude=5,
    width=50,
    period=500,
    offset=25 + 273.15)
    "Borefield entering water temperature"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController AmbCirCon(
    dTGeo=5,
    dTHex=5)
  "Ambient water circuit control"
    annotation (Placement(transformation(extent={{22,20},{42,40}})));
  Modelica.Blocks.Sources.BooleanPulse reqHea(
    width=50,
    period=500)
    "Heating is required signal"
    annotation (Placement(transformation(extent={{-60,62},{-40,82}})));
  Modelica.Blocks.Sources.BooleanPulse valHea(
    width=50,
    period=500,
    startTime=250)
    "Status of the two way valve on the hot water circuit side."
    annotation (Placement(transformation(extent={{-60,32},{-40,52}})));
  Modelica.Blocks.Sources.BooleanConstant rejCooFulLoa(
    k=false)
    "Reject cooling full load"
    annotation (Placement(transformation(extent={{-60,-58},{-40,-38}})));
  Modelica.Blocks.Sources.BooleanConstant reqCoo(
    k=false)
    "Cooling is required signal"
    annotation (Placement(transformation(extent={{-60,-88},{-40,-68}})));
equation
  connect(AmbCirCon.reqHea, reqHea.y) annotation (Line(points={{21,39.8},{-28,39.8},
          {-28,72},{-39,72}},
                           color={255,0,255}));
  connect(valHea.y, AmbCirCon.valHea) annotation (Line(points={{-39,42},{-30,42},
          {-30,37.6},{21,37.6}},
                            color={255,0,255}));
  connect(AmbCirCon.valCoo, valCoo.y) annotation (Line(points={{21,35.2},{-36,35.2},
          {-36,12},{-39,12}},
                          color={255,0,255}));
  connect(reHeajFulLoa.y, AmbCirCon.rejHeaFulLoa) annotation (Line(points={{-39,-18},
          {-32,-18},{-32,33},{21,33}},
                                   color={255,0,255}));
  connect(rejCooFulLoa.y, AmbCirCon.rejCooFulLoa) annotation (Line(points={{-39,-48},
          {-30,-48},{-30,31},{21,31}},
                                     color={255,0,255}));
  connect(reqCoo.y, AmbCirCon.reqCoo) annotation (Line(points={{-39,-78},{-28,-78},
          {-28,29},{21,29}},color={255,0,255}));
  connect(TBorEnt.y, AmbCirCon.TBorEnt) annotation (Line(points={{1,-50},{12,-50},
          {12,19.2},{21,19.2}}, color={0,0,127}));
  connect(con.y[1], AmbCirCon.TBorMaxEnt) annotation (Line(points={{1,-18.75},{2,
          -18.75},{2,27},{21,27}}, color={0,0,127}));
  connect(con.y[2], AmbCirCon.TDisHexEnt) annotation (Line(points={{1,-18.25},{4,
          -18.25},{4,25},{21,25}}, color={0,0,127}));
  connect(con.y[3], AmbCirCon.TDisHexLvg) annotation (Line(points={{1,-17.75},{6,
          -17.75},{6,23},{21,23}}, color={0,0,127}));
  connect(con.y[4], AmbCirCon.TBorLvg) annotation (Line(points={{1,-17.25},{8,-17.25},
          {8,21.2},{21,21.2}}, color={0,0,127}));
annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false,
                extent={{-100,-100},{100,100}}),
        graphics={Line(points={{-22,22}}, color={28,108,200})}),
        experiment(StopTime=500,Tolerance=1e-06,__Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Validation/AmbientCircuitController.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the controller block
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 20, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AmbientCircuitController;
