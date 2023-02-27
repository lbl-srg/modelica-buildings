within Buildings.Experimental.DHC.Loads.BaseClasses.Validation;
model SimpleRoomODE
  "Validation of the model SimpleRoomODE"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Source side medium";
  package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=112000 "Design heating heat flow rate (for TInd=TIndHea_nominal, TOut=TOutHea_nominal,
    with no internal gains, no solar radiation)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-200000
    "Design cooling heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Time tau=1800
    "Time constant of the indoor temperature";
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Office romHeaMet
    "ROM where the heating load is always met"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=276.15,
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.Continuous.LimPID conHea(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=10)
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=
        QHea_flow_nominal) "Scaling"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{82,130},{62,150}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Office romHeaUnm
    "ROM where the heating load is not met"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(k=0.7)
    "Scaling "
    annotation (Placement(transformation(extent={{92,90},{112,110}})));
  HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{82,70},{62,90}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.SimpleRoomODE rooOdeHea(
    dTEnv_nominal=20,
    TAir_start=293.15,
    QEnv_flow_nominal=QHea_flow_nominal,
    tau=tau)
    "ODE heated room model"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(
    k=297.15,
    y(final unit="K",
      displayUnit="degC"))
    "Maximum temperature set point"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=10,
    reverseActing=false)
    "PI controller tracking the room maximum temperature"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(k=
        QCoo_flow_nominal) "Scaling"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.SimpleRoomODE rooOdeCoo(
    dTEnv_nominal=20,
    TAir_start=293.15,
    QEnv_flow_nominal=QHea_flow_nominal,
    tau=tau)
    "ODE cooled room model"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(k=0.8)
    "Scaling"
    annotation (Placement(transformation(extent={{92,-90},{112,-70}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=293.15,
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Office romCooMet
    "ROM where the cooling load is always met"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding.Office romCooUnm
    "ROM where the cooling load is not met"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow3
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{82,-150},{62,-130}})));
equation
  connect(weaDat.weaBus,romHeaMet.weaBus)
    annotation (Line(points={{-120,100},{0,100},{0,99.8},{-6,99.8}},color={255,204,51},thickness=0.5));
  connect(romHeaMet.TAir,conHea.u_m)
    annotation (Line(points={{11,100},{40,100},{40,108}},color={0,0,127}));
  connect(conHea.y,gai.u)
    annotation (Line(points={{51,120},{58,120}},color={0,0,127}));
  connect(gai.y,prescribedHeatFlow.Q_flow)
    annotation (Line(points={{82,120},{126,120},{126,140},{82,140}},color={0,0,127}));
  connect(prescribedHeatFlow.port,romHeaMet.port_a)
    annotation (Line(points={{62,140},{0,140},{0,110}},color={191,0,0}));
  connect(conCoo.y,gai2.u)
    annotation (Line(points={{51,-100},{58,-100}},color={0,0,127}));
  connect(gai1.y,prescribedHeatFlow1.Q_flow)
    annotation (Line(points={{114,100},{120,100},{120,80},{82,80}},color={0,0,127}));
  connect(gai1.y,rooOdeHea.QAct_flow)
    annotation (Line(points={{114,100},{120,100},{120,6},{-14,6},{-14,12},{-12,12}},color={0,0,127}));
  connect(gai2.y,rooOdeCoo.QReq_flow)
    annotation (Line(points={{82,-100},{126,-100},{126,-34},{-20,-34},{-20,-20},{-12,-20}},color={0,0,127}));
  connect(prescribedHeatFlow1.port,romHeaUnm.port_a)
    annotation (Line(points={{62,80},{0,80},{0,70}},color={191,0,0}));
  connect(gai2.y,gai3.u)
    annotation (Line(points={{82,-100},{86,-100},{86,-80},{90,-80}},color={0,0,127}));
  connect(gai3.y,rooOdeCoo.QAct_flow)
    annotation (Line(points={{114,-80},{120,-80},{120,-40},{-14,-40},{-14,-28},{-12,-28}},color={0,0,127}));
  connect(weaDat.weaBus,romHeaUnm.weaBus)
    annotation (Line(points={{-120,100},{-20,100},{-20,59.8},{-6,59.8}},color={255,204,51},thickness=0.5));
  connect(weaDat1.weaBus,romCooMet.weaBus)
    annotation (Line(points={{-120,-100},{-20,-100},{-20,-120.2},{-6,-120.2}},color={255,204,51},thickness=0.5));
  connect(weaDat1.weaBus,romCooUnm.weaBus)
    annotation (Line(points={{-120,-100},{-20,-100},{-20,-80.2},{-6,-80.2}},color={255,204,51},thickness=0.5));
  connect(romCooMet.TAir,conCoo.u_m)
    annotation (Line(points={{11,-120},{40,-120},{40,-112}},color={0,0,127}));
  connect(gai.y,gai1.u)
    annotation (Line(points={{82,120},{86,120},{86,100},{90,100}},color={0,0,127}));
  connect(gai.y,rooOdeHea.QReq_flow)
    annotation (Line(points={{82,120},{126,120},{126,0},{-20,0},{-20,20},{-12,20}},color={0,0,127}));
  connect(gai3.y,prescribedHeatFlow2.Q_flow)
    annotation (Line(points={{114,-80},{120,-80},{120,-60},{80,-60}},color={0,0,127}));
  connect(prescribedHeatFlow2.port,romCooUnm.port_a)
    annotation (Line(points={{60,-60},{0,-60},{0,-70}},color={191,0,0}));
  connect(gai2.y,prescribedHeatFlow3.Q_flow)
    annotation (Line(points={{82,-100},{120,-100},{120,-140},{82,-140}},color={0,0,127}));
  connect(prescribedHeatFlow3.port,romCooMet.port_a)
    annotation (Line(points={{62,-140},{0,-140},{0,-110}},color={191,0,0}));
  connect(minTSet.y,conHea.u_s)
    annotation (Line(points={{-118,160},{20,160},{20,120},{28,120}},color={0,0,127}));
  connect(minTSet.y,rooOdeHea.TSet)
    annotation (Line(points={{-118,160},{-40,160},{-40,28},{-12,28}},color={0,0,127}));
  connect(maxTSet.y,conCoo.u_s)
    annotation (Line(points={{-118,-160},{20,-160},{20,-100},{28,-100}},color={0,0,127}));
  connect(maxTSet.y,rooOdeCoo.TSet)
    annotation (Line(points={{-118,-160},{-40,-160},{-40,-12},{-12,-12}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1209600,
      Tolerance=1e-06),
    Documentation(
      info="
<html>
<p>
This example validates
<a href=\"Buildings.Experimental.DHC.Loads.BaseClasses.SimpleRoomODE\">
Buildings.Experimental.DHC.Loads.BaseClasses.SimpleRoomODE</a> by comparison with
<a href=\"Buildings.ThermalZones.ReducedOrder.RC.TwoElements\">
Buildings.ThermalZones.ReducedOrder.RC.TwoElements</a>.
<p>
A first instance of the reduced order model is used to assess the heating and
cooling loads. A second instance is used to assess the indoor air temperature
variation when the rate at which heating or cooling is provided is lower than
the load. That second instance is used as a reference for the validation.
</p>
<p>
Eventually the validation is performed with two sets of ambient conditions,
one requiring heating, and the second requiring cooling.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 26, 2023, by Michael Wetter:<br/>
Updated parameter names.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Validation/SimpleRoomODE.mos" "Simulate and plot"),
    Diagram(
      coordinateSystem(
        extent={{-180,-200},{180,200}})));
end SimpleRoomODE;
