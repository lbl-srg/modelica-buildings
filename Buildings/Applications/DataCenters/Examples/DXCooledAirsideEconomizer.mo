within Buildings.Applications.DataCenters.Examples;
model DXCooledAirsideEconomizer
  "Example that illustrates the use of Buildings.Fluid.HeatExchanger.DXCoil in a data center room"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Air;

  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 291.15
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 297.15
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature SATSet = 290.93
    "Nominal room air temperature";
 /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -2*QRooInt_flow;
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3";
  parameter Modelica.SIunits.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=
    QRooC_flow_nominal
    "Cooling load of coil";

  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = Medium,
    rooLen=50,
    rooHei=3,
    rooWid=40,
    QRoo_flow=QRooInt_flow,
    m_flow_nominal=mA_flow_nominal,
    nPorts=2) "Simplified data center room"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=400,
    datCoi=datCoi,
    minSpeRat=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=303.15)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{82,-70},{102,-50}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-170,60},{-150,80}}),
        iconTransformation(extent={{-170,60},{-150,80}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=true,
    nominalValuesDefineDefaultPressureCurve=true)
    "Supply air fan"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={178,-60})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{150,-40},{170,-20}})));
  Buildings.Controls.Continuous.LimPID dxSpe(
    Td=1,
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    k=1)
    "Controller for variable speed DX coil"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
   redeclare package Medium = Medium,
   m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{128,-70},{148,-50}})));
  Modelica.Blocks.Sources.Constant SATSetPoi(k=SATSet)
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi(
    nSta=4,
    sta={
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/8),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(3/8)),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(1/2),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(1/2)),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*(3/4),
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal*(3/4)),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_II()),
     Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=mA_flow_nominal),
        perCur=
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_III())})
        "Coil data"
    annotation (Placement(transformation(extent={{180,80},{200,100}})));
  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = Medium,
    mOut_flow_nominal=mA_flow_nominal,
    dpOut_nominal=20,
    mRec_flow_nominal=mA_flow_nominal,
    dpRec_nominal=20,
    mExh_flow_nominal=mA_flow_nominal,
    dpExh_nominal=20)
    "Airside economizer"
    annotation (Placement(transformation(extent={{-80,-4},{-60,16}})));
  Buildings.Fluid.Sources.Outside out(
              redeclare package Medium = Medium, nPorts=2)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Applications.DataCenters.Examples.BaseClasses.CoolingMode
    cooModCon(tWai=1200) "Cooling mode controller"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam1(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Open only when free cooling mode is activated"
    annotation (Placement(transformation(extent={{60,2},{80,22}})));
  Buildings.Fluid.Actuators.Dampers.Exponential dam2(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "open when mechanical cooling is activated"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMixAir(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for mixed air"
    annotation (Placement(transformation(extent={{-30,2},{-10,22}})));
  Buildings.Applications.DataCenters.Examples.BaseClasses.AirsideEconomizerController
    ecoCon(
    Ti=60,
    minOAFra=0.15,
    gai=1) "Economzier controller"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Sources.RealExpression freCoo(y=if cooModCon.y == Integer(
        Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FreeCooling)
         then 1 else 0) "Set true if free cooling mode is on"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Modelica.Blocks.Math.Feedback feedback1
    "Feedback signal"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    "Constant output with value 1"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
equation
  connect(weaDat.weaBus, weaBus)
    annotation (Line(
      points={{-180,70},{-180,70},{-160,70}},
      color={255,204,51},
      thickness=0.5));
  connect(mAir_flow.y, fan.m_flow_in)
    annotation (Line(points={{171,-30},{178,-30},{178,-48}},
                     color={0,0,127}));
  connect(fan.port_a, senTemSupAir.port_b)
    annotation (Line(points={{168,-60},{168,-60},{148,-60}},
                                                          color={0,127,255}));
  connect(senTemSupAir.port_a, varSpeDX.port_b)
    annotation (Line(points={{128,-60},{128,-60},{102,-60}},
                  color={0,127,255}));
  connect(weaBus, out.weaBus)
    annotation (Line(
      points={{-160,70},{-160,70},{-160,10},{-150,10},{-150,10.2},{-140,10.2}},
      color={255,204,51},
      thickness=0.5));
  connect(dam2.port_b, varSpeDX.port_a)
    annotation (Line(points={{20,-60},{20,-60},{82,-60}}, color={0,127,255}));
  connect(dam1.port_b, senTemSupAir.port_a)
    annotation (Line(points={{80,12},{80,12},{120,12},{120,-8},{120,-60},{128,
          -60}},                   color={0,127,255}));
  connect(SATSetPoi.y, cooModCon.TSupSet) annotation (Line(points={{-139,100},{
          -102,100},{-102,78},{-92,78}}, color={0,0,127}));
  connect(eco.port_Sup, senTemMixAir.port_a)
    annotation (Line(points={{-60,12},{-60,12},{-30,12}},
                                               color={0,127,255}));
  connect(senTemMixAir.port_b, dam1.port_a)
    annotation (Line(points={{-10,12},{-10,12},{60,12}},
      color={0,127,255}));
  connect(senTemMixAir.port_b, dam2.port_a)
    annotation (Line(points={{-10,12},{-10,12},{-10,-60},{0,-60}},
                                           color={0,127,255}));
  connect(SATSetPoi.y, ecoCon.TMixAirSet) annotation (Line(points={{-139,100},{
          -108,100},{-54,100},{-54,86},{-42,86}}, color={0,0,127}));
  connect(senTemMixAir.T, ecoCon.TMixAirMea) annotation (Line(points={{-20,23},
          {-20,54},{-54,54},{-54,80},{-42,80}}, color={0,0,127}));
  connect(ecoCon.y, eco.y)
    annotation (Line(points={{-19,80},{-12,80},{-12,58},{-12,38},{-70,38},{-70,
          18}},                                           color={0,0,127}));
  connect(SATSetPoi.y, dxSpe.u_s)
    annotation (Line(points={{-139,100},{28,100},{28,-20},{38,-20}},
                                  color={0,0,127}));
  connect(senTemSupAir.T, dxSpe.u_m)
    annotation (Line(points={{138,-49},{138,-49},{138,-44},{50,-44},{50,-32}},
                                         color={0,0,127}));
  connect(dxSpe.y, varSpeDX.speRat)
    annotation (Line(points={{61,-20},{70,-20},{70,-52},{81,-52}},
                              color={0,0,127}));
  connect(feedback1.y, dam2.y)
    annotation (Line(points={{59,130},{78,130},{80,130},{80,40},{10,40},{10,-48}},
                            color={0,0,127}));
  connect(freCoo.y, dam1.y)
    annotation (Line(points={{41,110},{41,110},{70,110},{70,24}},
                        color={0,0,127}));
  connect(freCoo.y, feedback1.u2)
    annotation (Line(points={{41,110},{50,110},{50,122}},
                                color={0,0,127}));
  connect(weaBus.TWetBul, varSpeDX.TConIn) annotation (Line(
      points={{-160,70},{-160,70},{-160,-80},{68,-80},{68,-57},{81,-57}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(out.ports[1], eco.port_Out)
    annotation (Line(points={{-120,12},{-80,12}}, color={0,127,255}));
  connect(eco.port_Exh, out.ports[2]) annotation (Line(points={{-80,0},{-92,0},
          {-92,8},{-120,8}}, color={0,127,255}));
  connect(weaBus.TDryBul, cooModCon.TOutDryBul) annotation (Line(
      points={{-160,70},{-140,70},{-140,72},{-140,73},{-92,73}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDewPoi, cooModCon.TOutDewPoi) annotation (Line(
      points={{-160,70},{-160,68},{-140,68},{-140,67},{-92,67}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.port_b, roo.airPorts[1]) annotation (Line(points={{188,-60},{200,
          -60},{200,-132},{152.475,-132},{152.475,-118.7}}, color={0,127,255}));
  connect(eco.port_Ret, roo.airPorts[2]) annotation (Line(points={{-60,0},{-60,
          0},{-50,0},{-50,-132},{148.425,-132},{148.425,-118.7}}, color={0,127,
          255}));
  connect(roo.TRooAir, cooModCon.TRet) annotation (Line(points={{161,-110},{161,
          -110},{180,-110},{180,-88},{-100,-88},{-100,62},{-92,62}}, color={0,0,
          127}));
  connect(const.y, feedback1.u1)
    annotation (Line(points={{21,130},{42,130}}, color={0,0,127}));
  connect(cooModCon.y, ecoCon.cooMod) annotation (Line(points={{-69,70},{-62,70},
          {-62,74},{-42,74}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -160},{220,180}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/Examples/DXCooledAirsideEconomizer.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example illustrates how to use <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed</a> in a cooling system for data center rooms.  
</p>
<h4>System description</h4>
<p>
A air-cooled direct expansion (DX) cooling system with an airside economizer is used for a data center room. 
For simplicity, the data center room has a constant cooling load. The DX cooling system includes a variable-speed 
compressor, a cooling coil and a constant speed fun. The airside economizer is located before DX package to pre-cool
the mixed air.
</p>
<h4>Control logic</h4>
<h5>Cooling mode control</h5>
<p>
This system can run in three cooling modes: free cooling (FC) mode, partially mechanical cooling (PMC) mode and 
fully mechanical cooling (FMC) mode.In FC mode, only the airside economizer is commanded to run. The supply air
temperature is maintained by adjusting the outdoor air damper.In PMC mode, the airside economizer and the DX 
cooling coil are commanded to run together. And in FMC mode, only the DX cooling coil is commanded to run.
</p>
<p>
A demonstration on how to switch among these three cooling modes is shown in 
<a href=\"modelica://Buildings.Applications.DataCenters.Examples.BaseClasses.CoolingMode\">
Buildings.Applications.DataCenters.Examples.BaseClasses.CoolingMode</a>.
</p>
<h5>Supply air temperature control</h5>
<p>
In FC mode, the supply air temperature is controlled by adjusting outdoor air damper. In PMC mode, the outdoor air
damper is fully open, and the speed of compressor in the DX unit can be adjusted to maintain the supply air temperature.
In FMC mode, the outdoor air damper is fully closed and the supply air temperature is maintained by manipulating the 
compressor speed.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StartTime=11880000,
      StopTime=12600000,
      Tolerance=1e-06));
end DXCooledAirsideEconomizer;
