within Buildings.Rooms.Examples.FLeXLab;
package Cells "Models of individual test cells"
  extends Modelica.Icons.Package;
  package BaseClasses
    "Base Classes used in the construction of FLeXLab test cells"
    extends Modelica.Icons.BasesPackage;
    model GenericTestCell
      "Generic model of a test cell. Can be extended to create specific cells"
      extends Modelica.Blocks.Interfaces.BlockIcon;

      //Medium declarations
      package MediumA =
          Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
        "Medium model for the fluid in the space";
      package MediumB = Buildings.Media.ConstantPropertyLiquidWater
        "Medium model for the fluid in the radiant slab";

      //Geometry declarations
      parameter Modelica.SIunits.Area A = 60.97 "Floor area of the test cell";
      parameter Modelica.SIunits.Length disPip = 0.2
        "Distance between the pipes";

      //Segment declarations
      parameter Integer nSegSlab = 10 "Number of segments in the slab";

      //Nominal condition declarations
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal_slab = 0.06
        "Nominal mass flow rate through the slab";

      //Emissivity declarations
      parameter Real SlabEmissivity = 0.88 "Emissivity of the radiant slab";

      //Number of Wall Declarations
      parameter Integer nConExtWin = 1 "Number of walls with windows";

      Rooms.MixedAir roo(
        hRoo=3.6576,
        AFlo=A,
        redeclare package Medium = MediumA,
        intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
        extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
        datConPar(
          layers={parCon},
          each A=34.63,
          each til=Buildings.HeatTransfer.Types.Tilt.Floor,
          each azi=Buildings.HeatTransfer.Types.Azimuth.W),
        nConExt=1,
        nPorts=2,
        nConPar=1,
        nConBou=0,
        datConExtWin(
          layers={SWal},
          each A=5.86*3.6576,
          glaSys={winCon},
          each hWin=1.8288,
          each wWin=5.86,
          ove(
            wR={0},
            wL={0},
            gap={0.1},
            dep={1}),
          each fFra=0.1,
          each til=Buildings.HeatTransfer.Types.Tilt.Wall,
          azi={Buildings.HeatTransfer.Types.Azimuth.S}),
        nConExtWin=nConExtWin,
        surBou(
          each A=A,
          each absIR=0.9,
          each absSol=0.9,
          each til=Buildings.HeatTransfer.Types.Tilt.Floor),
        nSurBou=1,
        datConExt(
          layers={rooCon},
          each A=A,
          each til=Buildings.HeatTransfer.Types.Tilt.Ceiling),
        lat=3.5141821682216e-06)
        annotation (Placement(transformation(extent={{-18,70},{22,110}})));
      Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
          A=A,
        redeclare package Medium = MediumB,
        iLayPip=1,
        pipe=pipe,
        m_flow_nominal=m_flow_nominal_slab,
        disPip=disPip,
        layers=slaCon)
        annotation (Placement(transformation(extent={{-8,14},{12,34}})));
      HeatTransfer.Convection.Interior con(
        A=A,
        til=0,
        conMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-12,52})));
      Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr=
            SlabEmissivity*A)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={24,52})));                                                      //Gr = emissivity * A * view factor. Per pg 79 of Introduction to Cold Regions Engineering (Dean Freitag, Terry McFadden) view factor for a floor to a room = 1 (assuming no windows)
      HeatTransfer.Sources.PrescribedTemperature preT
        "Temperature of the ground"                                    annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={6,-10})));
      Modelica.Blocks.Sources.CombiTimeTable TGro(table=[0,288.15; 86400,288.15])
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={6,-42})));
      Fluid.Sources.MassFlowSource_T watIn(
        redeclare package Medium = MediumB,
        nPorts=1,
        use_m_flow_in=true,
        use_T_in=true) "Inlet water conditions (from central plant)"
        annotation (Placement(transformation(extent={{-62,14},{-42,34}})));
      Fluid.Sources.Boundary_pT watOut(nPorts=1, redeclare package Medium = MediumB)
        "Water outlet"
                     annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={50,24})));
      Modelica.Blocks.Sources.CombiTimeTable watCon(table=[0,0.06,303.15; 86400,0.06,
            303.15]) "Inlet water conditions (m_flow = y[1], T = y[2])"
        annotation (Placement(transformation(extent={{-118,18},{-98,38}})));
      HeatTransfer.Data.OpaqueConstructions.Generic slaCon(nLay=3, material={
            Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.1524,
            k=1.13,
            c=1000,
            d=1400,
            nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.127,
            k=0.036,
            c=1200,
            d=40),Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.2,
            k=1.8,
            c=1100,
            d=2400)}) "Construction of the slab"
        annotation (Placement(transformation(extent={{120,20},{140,40}})));
                   //fixme - Don't actually know width thickness of reinforced concrete foundation (3rd layer)

      Fluid.Data.Pipes.PEX_RADTEST pipe
        annotation (Placement(transformation(extent={{120,-2},{140,18}})));
      HeatTransfer.Data.OpaqueConstructions.Generic parCon(nLay = 3, material={
            Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.015875,
            k=0.17,
            c=1070,
            d=600),Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.0889,
            k=0.024,
            c=1006,
            d=1.225),Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.015875,
            k=0.17,
            c=1070,
            d=600)}) "Construction details for partition walls"
        annotation (Placement(transformation(extent={{120,44},{140,64}})));
                     //fixme - Is it legit to use this model for air gap (2nd layer)? Probably b/c partition wall (only care about thermal mass, not heat transfer)
      HeatTransfer.Data.OpaqueConstructions.Generic rooCon(nLay=3, material={
            Buildings.HeatTransfer.Data.Solids.Generic(
            x=  0.0127,
            k=  0.1,
            c=  1210,
            d=  540), Buildings.HeatTransfer.Data.Solids.Generic(
            x=  0.127,
            k=  0.036,
            c=  1200,
            d=  40), Buildings.HeatTransfer.Data.Solids.Generic(
            x=  0.00635,
            k=  43,
            c=  490,
            d=  7850)}) "Construction of the roof"
        annotation (Placement(transformation(extent={{120,66},{140,86}})));

      //fixme - Roof construction is completely made up. Inadequate information available, only know that insulation is R20. Currently 1/2" plywood => R20 insul => 1/2 in steel sheeting

      BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="/home/peter/FLeXLab/FLeXLab/bie/modelica/Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
        annotation (Placement(transformation(extent={{-10,160},{10,180}})));
      Modelica.Blocks.Sources.CombiTimeTable intGai(table=[0,0,1,0; 86400,0,1,0])
        "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
        annotation (Placement(transformation(extent={{-140,108},{-120,128}})));
      Modelica.Blocks.Sources.CombiTimeTable shaPos(table=[0,1; 86400,1])
        "Position of the shade"
        annotation (Placement(transformation(extent={{-106,138},{-86,158}})));
      Modelica.Blocks.Routing.Multiplex3 multiplex3_1
        annotation (Placement(transformation(extent={{-98,108},{-78,128}})));
      Fluid.Sources.MassFlowSource_T airIn(
        nPorts=1,
        redeclare package Medium = MediumA,
        use_m_flow_in=true,
        use_T_in=true) "Inlet air conditions (from AHU)"
        annotation (Placement(transformation(extent={{-110,80},{-90,100}})));
      Fluid.Sources.Boundary_pT airOut(nPorts=1, redeclare package Medium = MediumA)
        annotation (Placement(transformation(extent={{-112,54},{-92,74}})));
      Modelica.Blocks.Sources.CombiTimeTable airCon(table=[0,0.1,293.15; 86400,0.1,293.15])
        "Inlet air conditions (y[1] = m_flow, y[2] = T)"
        annotation (Placement(transformation(extent={{-168,84},{-148,104}})));
      HeatTransfer.Data.OpaqueConstructions.Generic SWal(nLay = 5, material= {
          Buildings.HeatTransfer.Data.Solids.Generic(
          x=  0.00635,
          k=  43,
          c=  490,
          d=  7850),Buildings.HeatTransfer.Data.Solids.Generic(
          x=  0.02413,
          k=  0.036,
          c=  1200,
          d=  40), Buildings.HeatTransfer.Data.Solids.Generic(
          x=  0.0127,
          k=  0.1,
          c=1210,
          d=540),Buildings.HeatTransfer.Data.Solids.Generic(
          x=  0.08255,
          k=  0.036,
          c=  1200,
          d=  40), Buildings.HeatTransfer.Data.Solids.Generic(
          x=  0.015875,
          k=  0.17,
          c=  1070,
          d=  600)}) "Construction of the south wall"
        annotation (Placement(transformation(extent={{120,90},{140,110}})));

      HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear winCon(
        UFra=2,
        haveInteriorShade=false,
        haveExteriorShade=false) "Construction of the windows"
        annotation (Placement(transformation(extent={{120,116},{140,136}})));
      //Do not currently have details on window construction. For now this is a generic window placeholder
      Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
        annotation (Placement(transformation(extent={{-62,138},{-42,158}})));
    equation
      connect(TGro.y[1], preT.T)                            annotation (Line(
          points={{6,-31},{6,-22}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sla.port_b,watOut. ports[1])    annotation (Line(
          points={{12,24},{40,24}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(watIn.ports[1], sla.port_a)    annotation (Line(
          points={{-42,24},{-8,24}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(watCon.y[1],watIn. m_flow_in)             annotation (Line(
          points={{-97,28},{-88,28},{-88,32},{-62,32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(watCon.y[2],watIn. T_in)             annotation (Line(
          points={{-97,28},{-64,28}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sla.surf_a, bodyRadiation.port_a) annotation (Line(
          points={{6,34},{6,38},{24,38},{24,42}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(sla.surf_a, con.solid) annotation (Line(
          points={{6,34},{6,38},{-12,38},{-12,42}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(sla.surf_b, preT.port)                  annotation (Line(
          points={{6,14},{6,0}},
          color={191,0,0},
          smooth=Smooth.None));
      //fixme - Is it necessary to add a heat transfer (convection, conduction, radiation) model connecting slab to ground?
      //fixme - Have multiple exterior construction. One for roof, one for walls. Need to modify room model to use both?
      //fixme - Can't find detailed information on windows in drawings. Windows specs stated in requirements spreadsheet (ASHRAE compliant). Have location information. Going to work with what's available for now
      //fixme - uSha input seems to have no impact in either this model or in Buildings.Rooms.MixedAir.Examples.MixedAirFreeResponse. Both are set to have Az = S so sun should shine through...right?
      //fixme - Currently N wall is not modeled. Ran out of constructions (conExt for roof, conExtWin for S, need one for heavily insulated N and one for less insulated N). What if assume that roof is adiabatic?

      connect(weaDat.weaBus, roo.weaBus) annotation (Line(
          points={{10,170},{19.9,170},{19.9,107.9}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(intGai.y[1], multiplex3_1.u1[1]) annotation (Line(
          points={{-119,118},{-112,118},{-112,125},{-100,125}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(intGai.y[2], multiplex3_1.u2[1]) annotation (Line(
          points={{-119,118},{-100,118}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(intGai.y[3], multiplex3_1.u3[1]) annotation (Line(
          points={{-119,118},{-112,118},{-112,111},{-100,111}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
          points={{-77,118},{-50,118},{-50,100},{-20,100}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(airIn.ports[1], roo.ports[1]) annotation (Line(
          points={{-90,90},{-40,90},{-40,80},{-15,80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(airOut.ports[1], roo.ports[2]) annotation (Line(
          points={{-92,64},{-40,64},{-40,80},{-11,80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
          points={{-147,94},{-128,94},{-128,98},{-110,98}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(airCon.y[2],airIn. T_in) annotation (Line(
          points={{-147,94},{-112,94}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(shaPos.y[1], replicator.u) annotation (Line(
          points={{-85,148},{-64,148}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(replicator.y, roo.uSha) annotation (Line(
          points={{-41,148},{-34,148},{-34,106},{-20,106}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(con.fluid, roo.surf_surBou[1]) annotation (Line(
          points={{-12,62},{-12,70},{-1.8,70},{-1.8,76}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(bodyRadiation.port_b, roo.surf_surBou[1]) annotation (Line(
          points={{24,62},{24,70},{-1.8,70},{-1.8,76}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
                -200},{200,200}}),      graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
    end GenericTestCell;
  end BaseClasses;
end Cells;
