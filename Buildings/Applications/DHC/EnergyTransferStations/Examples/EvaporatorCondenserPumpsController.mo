within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model EvaporatorCondenserPumpsController
  "Example of the evaporator and condenser pumps controller"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumMinLoa(k=0.2)
    "Minimum speed for the condenser side pump"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.BooleanPulse heaMod(
    width=50,
    period=200,
    startTime=0)
    "Step control"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.BooleanConstant CooMod(k=false)
    "Step control"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Sources.Ramp mSecCoo(
    height=0.5,
    duration=200,
    offset=1)
    "Secondary(building side) circuit chilled water flow rate "
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Ramp mSecHea(
    height=1.2,
    duration=200,
    offset=0.5)
    "Secondary(building side) circuit heating water flow rate "
    annotation (Placement(transformation(extent={{2,20},{22,40}})));
  Control.EvaporatorCondenserPumpsController pumCon
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.Ramp mCon(
    height=0.5,
    duration=200,
    offset=0.5)
    "Condenser water flow rate"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Sources.Ramp mEva(
    height=0.5,
    duration=200,
    offset=0.5)
    "Evaporator water flow rate"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumMinSoa(k=0.2)
    "Minimum speed for the evaporator side pump"
    annotation (Placement(transformation(extent={{-40,-42},{-20,-22}})));
equation
  connect(pumCon.reqHea, heaMod.y) annotation (Line(points={{88.6,10},{88,10},{88,
          70},{81,70}},     color={255,0,255}));
  connect(CooMod.y,pumCon.reqCoo)  annotation (Line(points={{81,-70},{88,-70},{
          88,-9.8},{88.6,-9.8}},
                              color={255,0,255}));
  connect(yPumMinLoa.y, pumCon.minConMasFlo) annotation (Line(points={{-18,30},
          {-18,0.6},{89.2,0.6}},    color={0,0,127}));
  connect(mCon.y, pumCon.mCon) annotation (Line(points={{61,30},{68,30},{68,8.4},
          {89.2,8.4}}, color={0,0,127}));
  connect(mSecHea.y,pumCon.mSecHea)  annotation (Line(points={{23,30},{30,30},{30,
          6.8},{89.2,6.8}},       color={0,0,127}));
  connect(mEva.y,pumCon.mEva)  annotation (Line(points={{61,-30},{68,-30},{68,-8},
          {89.2,-8}},         color={0,0,127}));
  connect(yPumMinSoa.y, pumCon.minEvaMasFlo)
    annotation (Line(points={{-18,-32},{-18,-1},{89.2,-1}},
                                                         color={0,0,127}));
  connect(mSecCoo.y, pumCon.mSecCoo) annotation (Line(points={{21,-30},{30,-30},
          {30,-6.8},{89.2,-6.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),  Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-100},{160,100}}),
        graphics={Line(points={{-22,22}}, color={28,108,200})}),
    experiment(StopTime=10000),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Control/EvaporatorCondenserPumpsController.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=10000),
Documentation(info="<html>
<p>
This model validates the controller block
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.EvaporatorCondenserPumpsController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.EvaporatorCondenserPumpsController</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
 <br/>
</li>
</ul>
</html>"));
end EvaporatorCondenserPumpsController;
