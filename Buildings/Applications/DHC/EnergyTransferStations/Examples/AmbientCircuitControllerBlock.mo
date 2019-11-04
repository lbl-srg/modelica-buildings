within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model AmbientCircuitControllerBlock
  "AmbientCircuitControllerValidation"
  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.TemperatureDifference dTHex = 5
    "Temperature difference in and out of substation heat exchanger";
  Modelica.Blocks.Sources.BooleanPulse valHea(width=50, period=500)
   "Heating side valve status"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Sources.BooleanConstant valCoo(k=false)
    "Cooling side valve status"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Constant TBorOut(k=30 + 273.15)
    "Borefield leaving water temperature"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Sources.Constant TEntEva(k=12 + 273.15)
    "Evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant TEntCon(k=35 + 273.15)
    "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-20,72},{0,92}})));
  Modelica.Blocks.Sources.Constant TDisHexEnt(k=18 + 273.15)
    "District heat exchnager entering water temperature"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Modelica.Blocks.Sources.Pulse TBorIn(
    amplitude=-5,
    width=50,
    period=250,
    offset=30 + 273.15)
    "Borefield entering water temperature"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Control.AmbientCircuitController AmbCirCon( dTHex=dTHex)
  "Ambient water circuit control"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Modelica.Blocks.Sources.Constant TDisHexLvg(k=12 + 273.15)
    "District heat exchnager leaving water temperature"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
equation
  connect(TEntEva.y, AmbCirCon.TEntEva) annotation (Line(points={{1,50},{16,50},
          {16,5.8},{31,5.8}}, color={0,0,127}));
  connect(TEntCon.y, AmbCirCon.TEntCon) annotation (Line(points={{1,82},{26,82},
          {26,8.2},{31,8.2}}, color={0,0,127}));
  connect(valCoo.y, AmbCirCon.valCoo) annotation (Line(points={{1,-10},{12,-10},
          {12,1.2},{31,1.2}},color={255,0,255}));
  connect(valHea.y, AmbCirCon.valHea) annotation (Line(points={{1,20},{12,20},{
          12,3.2},{31,3.2}},color={255,0,255}));
  connect(TBorIn.y, AmbCirCon.TBorIn) annotation (Line(points={{1,-40},{16,-40},
          {16,-2},{31,-2}}, color={0,0,127}));
  connect(TBorOut.y, AmbCirCon.TBorOut) annotation (Line(points={{1,-70},{20,-70},
          {20,-4.6},{31,-4.6}}, color={0,0,127}));
  connect(TDisHexLvg.y, AmbCirCon.TDisHexLvg) annotation (Line(points={{1,-130},
          {26,-130},{26,-10},{31,-10}}, color={0,0,127}));
  connect(TDisHexEnt.y, AmbCirCon.TDisHexEnt) annotation (Line(points={{1,-100},
          {24,-100},{24,-7.6},{31,-7.6}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -160},{100,100}}),
        graphics={Line(points={{-22,22}}, color={28,108,200})}),
    experiment(StopTime=1500),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Control/AmbientCircuitControllerBlock.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
         Documentation(info="<html>
<p>
This model validates the controller block
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
 <br/>
</li>
</ul>
</html>"));
end AmbientCircuitControllerBlock;
