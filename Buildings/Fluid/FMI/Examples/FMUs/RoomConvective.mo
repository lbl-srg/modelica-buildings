within Buildings.Fluid.FMI.Examples.FMUs;
block RoomConvective "Simple thermal zone"
  extends Buildings.Fluid.FMI.RoomConvective(
    redeclare final package Medium = MediumA, nFluPor = nFluPorts,
    theHvaAda(nFluPor=2));

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nFluPorts = 2
    "Number of fluid stream coming from the HVAC system.";

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 "Heat recovery effectiveness";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";
  parameter Modelica.SIunits.Temperature THeaRecLvg=
    TOut_nominal - eps*(TOut_nominal-TRooSet)
    "Air temperature leaving the heat recovery";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.SIunits.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=4*
    (QRooC_flow_nominal + mA_flow_nominal*(TASup_nominal-THeaRecLvg-dTFan)*1006)
    "Cooling load of coil, taking into account economizer, and increased due to latent heat removal";

  /////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.SIunits.Temperature TWSup_nominal = 273.15+16
    "Water supply temperature";
  parameter Modelica.SIunits.Temperature TWRet_nominal = 273.15+12
    "Water return temperature";
  parameter Modelica.SIunits.MassFlowRate mW_flow_nominal=
    QCoiC_flow_nominal/(TWRet_nominal-TWSup_nominal)/4200
    "Nominal water mass flow rate";

   Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRad
    "Radiative temperature"
    annotation (Placement(transformation(extent={{0,80},{-20,100}})));
  Modelica.Blocks.Sources.Constant radTem(k=295.13)
    annotation (Placement(transformation(extent={{40,80},{20,100}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{98,134},{78,154}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{14,134},{34,154}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
        rotation=90,
        origin={-28,200}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-28,200})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         TOut1
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,22},{0,42}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,22},{40,42}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
        QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{100,60},{80,80}})));
  MixingVolumes.MixingVolumeMoistAir
                                   vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    mSenFac=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{86,0},{106,20}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{78,144},{24,144}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(theCon.port_b,vol. heatPort)
    annotation (Line(points={{40,32},{40,10},{86,10}},
                                                    color={191,0,0}));
  connect(preHea.port,vol. heatPort)
    annotation (Line(points={{80,70},{60,70},{60,10},{86,10}},
                                                            color={191,0,0}));
  connect(TOut1.T, weaBus.TDryBul) annotation (Line(points={{-22,32},{-40,32},{-40,
          144},{24,144}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut1.port, theCon.port_a)
    annotation (Line(points={{0,32},{0,32},{20,32}}, color={191,0,0}));
  connect(theHvaAda.heaPorRad, TRad.port) annotation (Line(points={{-63.8182,
          144.533},{-28,144.533},{-28,90},{-20,90}},
                                            color={191,0,0}));
  connect(TRad.T, radTem.y)
    annotation (Line(points={{2,90},{19,90}}, color={0,0,127}));
  connect(weaBus.TDryBul, TOut) annotation (Line(
      points={{24,144},{-4,144},{-28,144},{-28,200}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(theHvaAda.TWat, vol.TWat) annotation (Line(points={{-85.8182,143.333},
          {-100,143.333},{-100,14.8},{84,14.8}}, color={0,0,127}));
  connect(theHvaAda.mWat_flow, vol.mWat_flow) annotation (Line(points={{
          -85.8182,146},{-108,146},{-108,18},{84,18}},
                                              color={0,0,127}));
  connect(theHvaAda.heaPorAir, vol.heatPort) annotation (Line(points={{-63.8182,
          159.333},{0,159.333},{0,120},{60,120},{60,10},{86,10}}, color={191,0,0}));
  connect(theHvaAda.ports[1], vol.ports[1]) annotation (Line(points={{-64,
          151.333},{-58,151.333},{-58,152},{-50,152},{-50,-10},{94,-10},{94,0}},
                                                                        color={0,
          127,255}));
  connect(theHvaAda.ports[2], vol.ports[2]) annotation (Line(points={{-64,
          151.333},{-54,151.333},{-54,-22},{98,-22},{98,0}},
                                                    color={0,127,255}));
    annotation(Dialog(tab="Assumptions"), Evaluate=true,
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={
        Text(
          extent={{-62,176},{-12,156}},
          lineColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}})),
    Documentation(info="<html>
<p>This example demonstrates how to export a model 
of a convective thermal zone that will be coupled 
to an air-based HVAC system. The thermal zone is 
taken from 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>. </p>
<p>The example extends from <a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">
Buildings.Fluid.FMI.RoomConvective</a> which provides 
the input and output signals that are needed to interface 
the acausal thermal zone model with causal connectors of FMI. 
The instance <code>theHvaAda</code> is the HVAC system 
adapter that contains on the right a fluid port, and on 
the left signal ports which are then used to connect at 
the top-level of the model to signal ports which are 
exposed at the FMU interface. </p>
</html>", revisions="<html>
<ul>
<li>April 28, 2016 by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/RoomConvective.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=15638400));
end RoomConvective;
