within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model AmbientCircuitController "Ambient water circuit controller validation"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanPulse reHeajFulLoa(width=50,
    period=250,
    startTime=375)
    "Reject full surplus heating load"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.BooleanConstant valCoo(
    k= false)
    "Status of the two way valve on the chilled water circuit side."
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  FifthGeneration.BaseClasses.Constants con(
    k={40 + 273.15,20 + 273.15,16 + 273.15,20 + 273.15},
    conNam={"TBorEntMax","TDisHexEnt","TDisHexLvg","TBorLvg"},
    nCon=4) "Multiple constant functions"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.Pulse TBorEnt(
    amplitude=5,
    width=50,
    period=500,
    offset=25 + 273.15)
    "Borefield entering water temperature"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls.Borefield
    conAmbCir(dTGeo=5, dTHex=5) "Ambient water circuit controller"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Sources.BooleanPulse reqHea(
    width=50,
    period=500)
    "Heating is required signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.BooleanPulse valHea(
    width=50,
    period=500,
    startTime=250)
    "Status of the two way valve on the hot water circuit side."
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.BooleanConstant rejCooFulLoa(
    k=false)
    "Reject cooling full load"
    annotation (Placement(transformation(extent={{-60,-62},{-40,-42}})));
  Modelica.Blocks.Sources.BooleanConstant reqCoo(
    k=false)
    "Cooling is required signal"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(conAmbCir.uHea, reqHea.y) annotation (Line(points={{39,39},{-28,39},{
          -28,70},{-39,70}}, color={255,0,255}));
  connect(valHea.y, conAmbCir.uIsoCon) annotation (Line(points={{-39,40},{-30,
          40},{-30,32},{38,32}}, color={255,0,255}));
  connect(conAmbCir.uIsoEva, valCoo.y) annotation (Line(points={{38,29},{-36,29},
          {-36,10},{-39,10}}, color={255,0,255}));
  connect(reHeajFulLoa.y, conAmbCir.uHeaRej) annotation (Line(points={{-39,-20},
          {-32,-20},{-32,38},{38,38}}, color={255,0,255}));
  connect(rejCooFulLoa.y, conAmbCir.uColRej) annotation (Line(points={{-39,-52},
          {-30,-52},{-30,35},{38,35}}, color={255,0,255}));
  connect(reqCoo.y, conAmbCir.uCoo) annotation (Line(points={{-39,-80},{-28,-80},
          {-28,34},{39,34}}, color={255,0,255}));
  connect(TBorEnt.y, conAmbCir.TBorWatEnt) annotation (Line(points={{1,-40},{12,
          -40},{12,26},{38,26}}, color={0,0,127}));
  connect(con.y[1],conAmbCir. TBorMaxEnt) annotation (Line(points={{1,-0.75},{2,
          -0.75},{2,25},{39,25}},  color={0,0,127}));
  connect(con.y[2],conAmbCir. TDisHexEnt) annotation (Line(points={{1,-0.25},{4,
          -0.25},{4,24},{39,24}},  color={0,0,127}));
  connect(con.y[3],conAmbCir. TDisHexLvg) annotation (Line(points={{1,0.25},{6,
          0.25},{6,23},{39,23}},   color={0,0,127}));
  connect(con.y[4], conAmbCir.TBorWatLvg) annotation (Line(points={{1,0.75},{8,
          0.75},{8,22},{39,22}}, color={0,0,127}));
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
