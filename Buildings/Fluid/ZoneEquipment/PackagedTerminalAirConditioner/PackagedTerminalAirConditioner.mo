within Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner;
model PackagedTerminalAirConditioner
  "System model for PTAC"
  extends Buildings.Fluid.ZoneEquipment.BaseClasses.EquipmentInterfaces(
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX,
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.ele,
    final has_varCoo=false,
    final has_varHea=true,
    final supHeaTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SupHeaSou.noHea,
    oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix,
    redeclare final package MediumHW = Buildings.Media.Water,
    redeclare final package MediumCHW = Buildings.Media.Water);

  parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal(
    final min = 0)
    "Nominal heat flow rate of electric heating coil"
    annotation(Dialog(enable=not has_HW, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.PressureDifference dpCooDX_nominal
    "Pressure drop for DX cooling coil at m_flow_nominal";

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedCooling CooCoi(
    redeclare final package Medium = MediumA,
    final show_T=true,
    final dp_nominal=dpCooDX_nominal,
    final datCoi=datCooCoi,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=datCooCoi.sta[1].nomVal.TEvaIn_nominal)
    "Single speed DX cooling coil"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Blocks.Routing.RealPassThrough TOut
    "Pass outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{-260,-50},{-240,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirCooCoi(
    redeclare final package Medium=MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Cooling coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{84,100},{104,120}})),
      Dialog(group="Fan parameters"));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCooCoi(
    final nSta=1)
    "DX cooling coil data"
    annotation (Placement(transformation(extent={{2,100},{22,120}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mAir_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAir_nominal)
    "Supply fan"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=QHeaCoi_flow_nominal) if not has_HW
    "Electric heating coil"
    annotation (Placement(transformation(extent={{182,-10},{202,10}})));

  Modelica.Blocks.Math.Gain gai(
    final k=mAir_flow_nominal)
    "Find mass flowrate value by multiplying nominal flowrate by normalized fan speed signal"
    annotation (Placement(transformation(extent={{-22,70},{-2,90}})));

  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Find normalized fan signal by dividing actual fan mass flowrate by nominal flowrate"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));

equation
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{-1,80},{10,80},{10,12}}, color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{21,5},{44,5},
          {44,82},{116,82},{116,110},{298,110}},
                                        color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-380,120},{-202,120},{-202,80},{-24,80}},
                                                  color={0,0,127}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{350,110},{350,130},{380,130}},
                                                   color={0,0,127}));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-330,30},{-310,30},{-310,-40},{-262,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(CooCoi.port_b, TAirCooCoi.port_a)
    annotation (Line(points={{100,0},{130,0}},color={0,127,255}));
  connect(vAirMix.port_b, fan.port_a)
    annotation (Line(points={{-80,0},{0,0}}, color={0,127,255}));
  connect(CooCoi.port_a, fan.port_b)
    annotation (Line(points={{80,0},{20,0}}, color={0,127,255}));
  connect(CooCoi.TOut, TOut.y) annotation (Line(points={{79,3},{60,3},{60,-40},{
          -239,-40}}, color={0,0,127}));
  connect(CooCoi.on, uCooEna) annotation (Line(points={{79,8},{50,8},{50,-20},{-78,
          -20},{-78,-130},{-380,-130}}, color={255,0,255}));
  connect(TAirCooCoi.port_b, heaCoiEle.port_a)
    annotation (Line(points={{150,0},{182,0}}, color={0,127,255}));
  connect(heaCoiEle.port_b, TAirLvg.port_a)
    annotation (Line(points={{202,0},{240,0}}, color={0,127,255}));
  connect(heaCoiEle.u, uHea) annotation (Line(points={{180,6},{172,6},{172,-58},
          {-160,-58},{-160,-90},{-380,-90}}, color={0,0,127}));
  connect(heaCoiEle.Q_flow, PHeaCoi) annotation (Line(points={{203,6},{220,6},{
          220,-80},{380,-80}}, color={0,0,127}));
  connect(CooCoi.P, PCooCoi) annotation (Line(points={{101,9},{120,9},{120,-40},
          {210,-40},{210,-120},{380,-120}}, color={0,0,127}));
  annotation (defaultComponentName = "ptac",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics={Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,240}},
          textString="%name",
          textColor={0,0,255})}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This is a packaged terminal air conditioner system model. The system consists of an 
    outdoor air mixer, a signle-speed direct expansion (DX) cooling coil, 
    an electric heating coil, and a constant speed supply air fan. 
    </p>
    <p>
    The control module for the system is implemented separately in 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController</a> and cycles the DX cooling coil, 
    electric heating coil, and fan to regulate the zone temperature based on the cooling and heating setpoints. 
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    June 21, 2023, by Junke Wang, Xing Lu, and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end PackagedTerminalAirConditioner;
