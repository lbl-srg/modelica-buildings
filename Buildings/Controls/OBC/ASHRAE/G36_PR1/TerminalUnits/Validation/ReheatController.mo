within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model ReheatController "Validate model for controlling VAV terminal box with reheat"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ReheatController
    reheatController(
    zonAre=50,
    samplePeriod=120,
    m_flow_nominal=(50*3*1.2/3600)*6)
    "Controller for VAV terminal unit with reheat"
    annotation (Placement(transformation(extent={{60,52},{80,82}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCoo(k=273.15 + 24)
    "Room cooling setpoint "
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirFlo(
    offset=0.02,
    height=0.0168,
    duration=3600) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    height=6,
    offset=273.15 + 17,
    duration=3600) "Measured room temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis(
    height=4,
    duration=3600,
    offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 14) "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHea(k=273.15 + 20)
    "Room heating setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

equation
  connect(TSetRooHea.y, reheatController.TRooHeaSet)
    annotation (Line(points={{-59,80},{-48,80},{-48,60},{44,60},{44,79},{58,79}},
      color={0,0,127}));
  connect(TSetRooCoo.y, reheatController.TRooCooSet)
    annotation (Line(points={{-19,80},{48,80},{48,75},{58,75}}, color={0,0,127}));
  connect(disAirFlo.y, reheatController.VDis)
    annotation (Line(points={{-59,40},{48,40},{48,71},{58,71}}, color={0,0,127}));
  connect(TZon.y, reheatController.TRoo)
    annotation (Line(points={{-19,20},{40,20},{40,67},{58,67}}, color={0,0,127}));
  connect(TDis.y, reheatController.TDis)
    annotation (Line(points={{-59,-10},{36,-10},{36,63},{58,63}}, color={0,0,127}));
  connect(TSup.y, reheatController.TSupAHU)
    annotation (Line(points={{-19,-40},{32,-40},{32,59},{58,59}}, color={0,0,127}));
  connect(opeMod.y, reheatController.uOpeMod)
    annotation (Line(points={{-19,-80},{26,-80},{26,55},{58,55}}, color={255,127,0}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Validation/ReheatController.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ReheatController\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ReheatController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ReheatController;
