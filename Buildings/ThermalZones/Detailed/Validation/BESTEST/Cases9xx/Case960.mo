within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case960 "Case 600, but with an unconditioned sun-space"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
    roo(
    nConExt=4,
    datConExt(
      layers={roof,matExtWal,matExtWal,matExtWal},
      A={48,6*2.7,6*2.7,8*2.7},
      til={C_,Z_,Z_,Z_},
      azi={S_,W_,E_,N_}),
    nConExtWin=0,
      datConExtWin(A={0}, hWin={0}, wWin={0}),
    nSurBou=1,
    surBou(
      each A=8*2.7,
      each absIR=0.9,
      each absSol=0.6,
      each til=Buildings.Types.Tilt.Wall)),
    souInf(nPorts=2),
    staRes(
      annualHea(Min=2.311*3.6e9, Max=3.373*3.6e9, Mean=2.846*3.6e9),
      annualCoo(Min=-0.411*3.6e9, Max=-0.803*3.6e9, Mean=-0.618*3.6e9),
      peakHea(Min=2.410*1000, Max=2.863*1000, Mean=2.701*1000),
      peakCoo(Min=-0.953*1000, Max=-1.404*1000, Mean=-1.212*1000)));

  Buildings.HeatTransfer.Conduction.MultiLayer
    parWal(layers=matLayPar, A=8*2.7,
    stateAtSurface_a=true,
    stateAtSurface_b=true)          "Partition wall between the two rooms"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={120,-42})));

  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120
    matLayPar(material={
        Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=0.510,
        c=1000,
        d=1400)}) "Construction material for partition walls"
    annotation (Placement(transformation(extent={{-50,-8},{-32,10}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase900
     extWalCase900 "Exterior wall"
    annotation (Placement(transformation(extent={{160,80},{174,94}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.FloorCase900
    floorCase900 "Floor"
    annotation (Placement(transformation(extent={{180,80},{194,94}})));

  Buildings.ThermalZones.Detailed.MixedAir sunSpa(
    redeclare package Medium = MediumA,
    hRoo=2.7,
    nPorts=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
    nConPar=0,
    nConExt=3,
    datConExt(
      layers={roof,extWalCase900,extWalCase900},
      A={8*2,2*2.7,2*2.7},
      til={C_,Z_,Z_},
      azi={S_,W_,E_}),
    nSurBou=1,
    surBou(
      each A=8*2.7,
      each absIR=0.9,
      each absSol=0.6,
      each til=Buildings.Types.Tilt.Wall),
    nConExtWin=1,
    datConExtWin(
      layers={extWalCase900},
      A={8*2.7},
      glaSys={window600},
      wWin={2*3},
      hWin={2},
      fFra={0.001},
      til={Z_},
      azi={S_}),
    nConBou=1,
    datConBou(
      layers={floorCase900},
      each A=2*8,
      each til=F_),
    AFlo=16,
    lat=0.69464104229374) "Room model for sun-space"
    annotation (Placement(transformation(extent={{154,-30},{184,0}})));
  Modelica.Blocks.Sources.Constant qConGai_flow1(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{80,16},{88,24}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow1(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{92,24},{100,32}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_2
    annotation (Placement(transformation(extent={{108,16},{116,24}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow1(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{92,8},{100,16}})));
  Buildings.HeatTransfer.Conduction.SingleLayer soiSunSpa(
    material=soil,
    steadyStateInitial=true,
    A=16,
    T_a_start=283.15,
    T_b_start=283.75) "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(
        extent={{5,-5},{-3,3}},
        rotation=-90,
        origin={175,-35})));
  Buildings.Fluid.Sources.MassFlowSource_T sinInf2(
    redeclare package Medium = MediumA,
    m_flow=1,
    use_m_flow_in=true,
    use_T_in=false,
    use_X_in=false,
    use_C_in=false,
    nPorts=1) "Sink model for sunspace infiltration"
    annotation (Placement(transformation(extent={{124,-144},{136,-132}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate1(k=-16*2.7*0.5/3600)
    "0.41 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{54,-134},{62,-126}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{74,-138},{84,-128}})));
  Buildings.Fluid.Sensors.Density density1(redeclare package Medium = MediumA)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{84,-162},{74,-152}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoiSunSpa[nConBou](
      each T=283.15) "Boundary condition for construction" annotation (
      Placement(transformation(
        extent={{0,0},{-8,8}},
        origin={194,-52})));
  Fluid.FixedResistances.PressureDrop heaCoo1(
    redeclare package Medium = MediumA,
    allowFlowReversal=false,
    m_flow_nominal=48*2.7*0.41/3600*1.2,
    dp_nominal=1,
    linearized=true,
    from_dp=true) "Heater and cooler"
    annotation (Placement(transformation(extent={{124,-120},{136,-108}})));
equation
  connect(sunSpa.uSha, replicator.y)
                                  annotation (Line(
      points={{152.8,-1.5},{122,-1.5},{122,80},{-3.6,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(parWal.port_a, roo.surf_surBou[1]) annotation (Line(
      points={{110,-42},{48.15,-42},{48.15,-25.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(parWal.port_b, sunSpa.surf_surBou[1])
                                             annotation (Line(
      points={{130,-42},{166,-42},{166,-25.5},{166.15,-25.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sunSpa.surf_conBou[1], soiSunSpa.port_b) annotation (Line(
      points={{173.5,-27},{173.5,-29.5},{174,-29.5},{174,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSoiSunSpa[1].port, soiSunSpa.port_a) annotation (Line(
      points={{186,-48},{174,-48},{174,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, sunSpa.weaBus)
                                     annotation (Line(
      points={{86,-88},{80,-88},{80,-1.575},{182.425,-1.575}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(qRadGai_flow1.y, multiplex3_2.u1[1]) annotation (Line(
      points={{100.4,28},{104,28},{104,22.8},{107.2,22.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow1.y, multiplex3_2.u2[1]) annotation (Line(
      points={{88.4,20},{107.2,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow1.y, multiplex3_2.u3[1]) annotation (Line(
      points={{100.4,12},{103.2,12},{103.2,17.2},{107.2,17.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_2.y, sunSpa.qGai_flow)
                                         annotation (Line(
      points={{116.4,20},{120,20},{120,-9},{152.8,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InfiltrationRate1.y, product1.u1) annotation (Line(
      points={{62.4,-130},{73,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(density1.d, product1.u2) annotation (Line(
      points={{73.5,-157},{66,-157},{66,-136},{73,-136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, sinInf2.m_flow_in)       annotation (Line(
      points={{84.5,-133},{103.25,-133},{103.25,-133.2},{124,-133.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCoo1.port_b, sunSpa.ports[1])
                                        annotation (Line(
      points={{136,-114},{144,-114},{144,-24.5},{157.75,-24.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinInf2.ports[1], sunSpa.ports[2])    annotation (Line(
      points={{136,-138},{148,-138},{148,-22.5},{157.75,-22.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(density1.port, sunSpa.ports[3])
                                       annotation (Line(
      points={{79,-162},{152,-162},{152,-20.5},{157.75,-20.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souInf.ports[2], heaCoo1.port_a) annotation (Line(
      points={{-12,-28},{-10,-28},{-10,-114},{124,-114}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case960.mos"
        "Simulate and plot"),
      experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-120,-240},{260,
            120}}), graphics={Text(
          extent={{106,-200},{252,-220}},
          lineColor={0,0,255},
          textString="SunZone"), Text(
          extent={{-12,-202},{134,-222}},
          lineColor={0,0,255},
          textString="BackZone")}),
            Documentation(revisions="<html>
<ul>
<li>
October 9, 2013, by Michael Wetter:<br/>
Corrected assignment of soil properties to avoid an error when checking
the model in pedantic mode.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
July 16, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used for the test case 960 of the BESTEST validation suite.
Case 960 is a two zones building, whereas the south-facing zone is
an unconditioned sun-space.
</p>
</html>"));
end Case960;
