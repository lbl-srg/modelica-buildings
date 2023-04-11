within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump;
model PackagedTerminalHeatPump
    extends Buildings.Fluid.ZoneEquipment.BaseClasses.EquipmentInterfaces(
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX,
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.heaPum,
    oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix,
    redeclare final package MediumHW =Modelica.Media.Interfaces.PartialMedium,
    redeclare final package MediumCHW =Modelica.Media.Interfaces.PartialMedium);
  parameter Modelica.Units.SI.HeatFlowRate QSup_flow_nominal
    "Heat flow rate for supplementary heating";
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.PressureDifference dpCooDX_nominal
    "Pressure drop for DX cooling coil at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpHeaDX_nominal
    "Pressure drop for DX heating coil at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpSupHea_nominal
    "Pressure drop for supplementary heating coil at m_flow_nominal";

  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{84,100},{104,120}})),
      Dialog(group="Fan parameters"));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCooCoi(nSta=1)
    "DX cooling coil data"
    annotation (Placement(transformation(extent={{2,100},{22,120}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mAir_flow_nominal,
    final per=fanPer,
    final dp_nominal=dpAir_nominal)
    "Supply fan"
    annotation (Placement(transformation(extent={{122,-10},{142,10}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u SupHeaCoi(
    redeclare final package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    show_T=true,
    dp_nominal=dpSupHea_nominal,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=datCooCoi.sta[1].nomVal.TEvaIn_nominal,
    Q_flow_nominal=QSup_flow_nominal)
    "Supplementary single speed DX heating coil"
    annotation (Placement(transformation(extent={{184,-10},{204,10}})));

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
      min=0))
    annotation (Placement(transformation(extent={{-260,-50},{-240,-30}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating HeaCoi(
    redeclare final package Medium = MediumA,
    show_T=true,
    dp_nominal=dpHeaDX_nominal,
    datCoi=datHeaCoi,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=datCooCoi.sta[1].nomVal.TEvaIn_nominal,
    datDef=datDef)
    "Single speed DX heating coil"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedCooling CooCoi(
    redeclare final package Medium = MediumA,
    show_T=true,
    dp_nominal=dpCooDX_nominal,
    datCoi=datCooCoi,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=datCooCoi.sta[1].nomVal.TEvaIn_nominal)
    "Single speed DX cooling coil"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Sensors.TemperatureTwoPort TAirCooCoi(redeclare final package Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
    "Cooling coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
  replaceable parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer datHeaCoi(nSta=1)
    "DX heating coil data"
    annotation (Placement(transformation(extent={{42,100},{62,120}})));
  Modelica.Blocks.Interfaces.RealInput uSupHea(final unit="1") if has_hea
    "Supplementary heating loop signal" annotation (Placement(transformation(
          extent={{-400,-30},{-360,10}}), iconTransformation(extent={{-240,-160},
            {-200,-120}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=2)
    annotation (Placement(transformation(extent={{-224,-50},{-204,-30}})));
  Sensors.TemperatureTwoPort TAirHeaCoi(redeclare final package Medium =
        MediumA, final m_flow_nominal=mAir_flow_nominal)
    "Heating coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  replaceable parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost datDef
    "DX heating coil defrost data"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
equation
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{-1,80},{132,80},{132,12}},
                                                       color={0,0,127}));
  connect(fan.m_flow_actual, gaiFanNor.u) annotation (Line(points={{143,5},{150,
          5},{150,80},{222,80},{222,110},{298,110}},
                                        color={0,0,127}));
  connect(uFan, gai.u)
    annotation (Line(points={{-380,120},{-202,120},{-202,80},{-24,80}},
                                                  color={0,0,127}));
  connect(gaiFanNor.y, yFan_actual)
    annotation (Line(points={{321,110},{370,110}}, color={0,0,127}));
  connect(fan.port_b, SupHeaCoi.port_a)
    annotation (Line(points={{142,0},{184,0}}, color={0,127,255}));
  connect(SupHeaCoi.port_b, TAirLvg.port_a)
    annotation (Line(points={{204,0},{240,0}}, color={0,127,255}));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-330,30},{-310,30},{-310,-40},{-262,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(vAirMix.port_b, CooCoi.port_a)
    annotation (Line(points={{-80,0},{-50,0}}, color={0,127,255}));
  connect(CooCoi.port_b, TAirCooCoi.port_a)
    annotation (Line(points={{-30,0},{-6,0}}, color={0,127,255}));
  connect(TAirCooCoi.port_b, HeaCoi.port_a)
    annotation (Line(points={{14,0},{46,0}}, color={0,127,255}));
  connect(uCooEna, CooCoi.on) annotation (Line(points={{-380,-120},{-74,-120},{
          -74,8},{-51,8}}, color={255,0,255}));
  connect(uHeaEna, HeaCoi.on) annotation (Line(points={{-380,-160},{-94,-160},{
          -94,-48},{30,-48},{30,8},{45,8}}, color={255,0,255}));
  connect(uSupHea, SupHeaCoi.u) annotation (Line(points={{-380,-10},{-338,-10},
          {-338,-54},{160,-54},{160,6},{182,6}},color={0,0,127}));
  connect(TOut.y, reaScaRep.u) annotation (Line(points={{-239,-40},{-231.5,-40},
          {-231.5,-40},{-226,-40}}, color={0,0,127}));
  connect(reaScaRep.y[1], CooCoi.TOut) annotation (Line(points={{-202,-41},{-62,
          -41},{-62,3},{-51,3}}, color={0,0,127}));
  connect(reaScaRep.y[2], HeaCoi.TOut) annotation (Line(points={{-202,-39},{26,
          -39},{26,3},{45,3}}, color={0,0,127}));
  connect(TAirHeaCoi.port_b, fan.port_a)
    annotation (Line(points={{100,0},{122,0}}, color={0,127,255}));
  connect(TAirHeaCoi.port_a, HeaCoi.port_b)
    annotation (Line(points={{80,0},{74,0},{74,0},{66,0}}, color={0,127,255}));
  connect(weaBus.pAtm, x_pTphi.p_in) annotation (Line(
      points={{-330,30},{-310,30},{-310,-74},{-262,-74}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, x_pTphi.T) annotation (Line(
      points={{-330,30},{-310,30},{-310,-80},{-262,-80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.relHum, x_pTphi.phi) annotation (Line(
      points={{-330,30},{-310,30},{-310,-86},{-262,-86}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(x_pTphi.X[1], HeaCoi.XOut) annotation (Line(points={{-239,-80},{-70,
          -80},{-70,-60},{40,-60},{40,-9},{45,-9}}, color={0,0,127}));
  annotation (defaultComponentName = "PTHP",
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
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalHeatPump/Examples/PackagedTerminalHeatPump.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This is a packaged terminal heat pump system model. The system consists of an outdoor air mixer, a signle-speed direct expansion (DX) cooling coil, a signle-speed DX heating coil, constant speed supply air fan, and a supplemental heating coil. </p>
<p>The control modules for the system are implemented separately in <a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls\">Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls</a>: </p>
<ul>
<li><a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil\">CyclingFanCyclingCoil</a>: Cycle the DX cooling coil, DX heating coil, electric supplementaty heating coil, and fan to regulate the zone temperature based on the heating and cooling setpoints. </li>
<li><a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.SupplementalHeating\">SupplementalHeating</a>: Turn on/off the supplemental heating based on the minimum outdoor air drybulb temperature limit.</li>
</ul>
</html>
", revisions="<html>
    <ul>
    <li>
    Mar 30, 2023 by Karthik Devaprasad, Xing Lu:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end PackagedTerminalHeatPump;
