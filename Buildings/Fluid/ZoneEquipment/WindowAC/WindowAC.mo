within Buildings.Fluid.ZoneEquipment.WindowAC;
model WindowAC
  "Window AC system model"
    extends Buildings.Fluid.ZoneEquipment.BaseClasses.EquipmentInterfaces(
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX,
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.noHea,
    final has_varCoo=false,
    final has_varHea=false,
    final supHeaTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SupHeaSou.noHea,
    oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix,
    redeclare final package MediumHW=Buildings.Media.Water,
    redeclare final package MediumCHW=Buildings.Media.Water);

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal
    "Pressure drop for DX cooling coil at m_flow_nominal";

  parameter Real looHys(unit="1")=0.01
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{50,100},{70,120}})),
      Dialog(group="Fan parameters"));

  replaceable parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCoi(
    final nSta=1)
    "Coil data"
    annotation (Placement(transformation(extent={{2,100},{22,120}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mAir_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAir_nominal)
    "Supply fan"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedCooling sinSpeDXCoo(
    redeclare final package Medium = MediumA,
    final show_T=true,
    final dp_nominal=dpDX_nominal,
    final datCoi=datCoi,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=datCoi.sta[1].nomVal.TEvaIn_nominal)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Math.Gain gai(
    final k=mAir_flow_nominal)
    "Find mass flowrate value by multiplying nominal flowrate by normalized fan speed signal"
    annotation (Placement(transformation(extent={{-22,70},{-2,90}})));

  Modelica.Blocks.Math.Gain gaiFanNor(
    final k=1/mAir_flow_nominal)
    "Find normalized fan signal by dividing actual fan mass flowrate by nominal flowrate"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));

  Modelica.Blocks.Routing.RealPassThrough TOut(y(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    final min=0))
    "Pass outdoor air temperature from the weatherbus"
    annotation (Placement(transformation(extent={{-260,-50},{-240,-30}})));

equation
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{-1,80},{2,80},{2,12}},   color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{13,5},{28,5},
          {28,80},{100,80},{100,110},{298,110}},
                                        color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-380,120},{-202,120},{-202,80},{-24,80}},
                                                  color={0,0,127}));
  connect(vAirMix.port_b, fan.port_a) annotation (Line(points={{-80,0},{-40,0},
          {-40,0},{-8,0}}, color={0,127,255}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{350,110},{350,130},{380,130}},
                                                   color={0,0,127}));
  connect(fan.port_b, sinSpeDXCoo.port_a) annotation (Line(points={{12,0},{90,0}},
                         color={0,127,255}));
  connect(sinSpeDXCoo.port_b, TAirLvg.port_a) annotation (Line(
        points={{110,0},{176,0},{176,0},{240,0}},     color={0,127,
          255}));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-330,30},{-310,30},{-310,-40},{-262,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TOut.y, sinSpeDXCoo.TOut) annotation (Line(points={{-239,-40},{60,-40},
          {60,3},{89,3}},             color={0,0,127}));
  connect(uCooEna, sinSpeDXCoo.on) annotation (Line(points={{-380,-130},{-80,-130},
          {-80,-60},{40,-60},{40,8},{89,8}}, color={255,0,255}));
  annotation (defaultComponentName = "winAC",
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
    This is a window air conditioner system model. The system consists of an 
    outdoor air mixer, a single-speed direct expansion (DX) cooling coil, 
    and a constant speed supply air fan. The coil meets the cooling load 
    by cycling on/off, while the fan can operate continuously or cycle 
    on/off in conjunction with the coil. 
    </p>
    <p>
    The control module for the system is implemented separately in 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController</a>. The controller
    cycles the DX cooling coil and fan to regulate the zone temperature based on the 
    cooling setpoint. 
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    June 21, 2023, by Xing Lu, Karthik Devaprasad, and Junke Wang:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end WindowAC;
