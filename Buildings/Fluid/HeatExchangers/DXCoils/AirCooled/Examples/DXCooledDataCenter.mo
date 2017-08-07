within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples;
model DXCooledDataCenter
  "Example that illustrates the use of Buildings.Fluid.HeatExchanger.DXCoil in a data center room"
  extends Modelica.Icons.Example;
  replaceable package Medium =
      Buildings.Media.Air;

  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
    "Nominal room air temperature";


 /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -2*QRooInt_flow;
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.SIunits.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=
    QRooC_flow_nominal
    "Cooling load of coil";

  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom datCenRoo(nPorts=2,
    redeclare package Medium = Medium,
    rooLen=50,
    rooHei=3,
    rooWid=40,
    QRoo_flow=QRooInt_flow,
    m_flow_nominal=mA_flow_nominal)
    "Simplified data center room"
    annotation (Placement(transformation(extent={{-16,48},{4,28}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=400,
    minSpeRat=0.2,
    datCoi=datCoi,
    T_start=303.15)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-18,-50},{2,-30}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3
                                            weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-72,-80},{-52,-60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Supply air fan"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={52,0})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Buildings.Controls.Continuous.LimPID conVarSpe(
    Td=1,
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.5,
    Ti=60)              "Controller for variable speed DX coil"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package
      Medium = Medium, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{22,-46},{34,-34}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRetAir(redeclare package
      Medium = Medium, m_flow_nominal=mA_flow_nominal,
    T_start=303.15)
    "Temperature sensor for return air"
    annotation (Placement(transformation(extent={{-44,22},{-56,34}})));
  Modelica.Blocks.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Data.Generic.DXCoil                                                  datCoi(
    nSta=4, sta={Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/8),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(3/8)),
        perCur=PerformanceCurves.Curve_I()),Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(1/2),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(1/2)),
        perCur=PerformanceCurves.Curve_I()),Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/4),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(3/4)),
        perCur=PerformanceCurves.Curve_II()),Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal),
        perCur=PerformanceCurves.Curve_III())}) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,-70},{-62,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(varSpeDX.TConIn, weaBus.TWetBul) annotation (Line(points={{-19,-37},{-48,
          -37},{-48,-70},{-62,-70}}, color={0,0,127}));
  connect(datCenRoo.airPorts[1], fan.port_b) annotation (Line(points={{-4.15,28},
          {-4.15,28},{52,28},{52,10}}, color={0,127,255}));
  connect(mAir_flow.y, fan.m_flow_in) annotation (Line(points={{79,0},{64,0},{64,
          -2.22045e-15}}, color={0,0,127}));
  connect(fan.port_a, senTemSupAir.port_b)
    annotation (Line(points={{52,-10},{52,-40},{34,-40}}, color={0,127,255}));
  connect(senTemSupAir.port_a, varSpeDX.port_b)
    annotation (Line(points={{22,-40},{2,-40}}, color={0,127,255}));
  connect(datCenRoo.airPorts[2], senTemRetAir.port_a)
    annotation (Line(points={{-7.85,28},{-44,28}}, color={0,127,255}));
  connect(senTemRetAir.port_b, varSpeDX.port_a) annotation (Line(points={{-56,28},
          {-68,28},{-68,-40},{-18,-40}}, color={0,127,255}));
  connect(TRooSetPoi.y, conVarSpe.u_s) annotation (Line(points={{-79,90},{-72,90},
          {-72,70},{-62,70}}, color={0,0,127}));
  connect(senTemRetAir.T, conVarSpe.u_m)
    annotation (Line(points={{-50,34.6},{-50,58}},          color={0,0,127}));
  connect(conVarSpe.y, varSpeDX.speRat) annotation (Line(points={{-39,70},{-28,70},
          {-28,-32},{-19,-32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirCooled/Examples/DXCooledDataCenter.mos"
        "Simulate and Plot"));
end DXCooledDataCenter;
