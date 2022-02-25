within Buildings.Experimental.DHC.Loads.BaseClasses.Validation;
model BuildingWithETS
  "Validation of the base class PartialBuildingWithPartialETS"
  extends Modelica.Icons.Example;
  import TypDisSys=Buildings.Experimental.DHC.Types.DistrictSystemType
    "District system type enumeration";
  package MediumW=Buildings.Media.Water
    "Water";
  package MediumS=Modelica.Media.Water.WaterIF97_ph (
    h_default=2770E3)
    "Steam";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=1E4
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=-1E4
    "Nominal mass flow rate";
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiHeaGen1(
    redeclare final package MediumSerHea_a=MediumS,
    redeclare final package MediumSer=MediumW,
    redeclare final package MediumBui=MediumW,
    nPorts_heaWat=1,
    bui(
      final have_heaWat=true),
    ets(
      final typ=TypDisSys.HeatingGeneration1,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal))
    "Building and ETS component - Heating only (steam)"
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  Fluid.Sources.MassFlowSource_T souDisSup(
    redeclare final package Medium=MediumS,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-240,210},{-220,230}})));
  Fluid.Sources.Boundary_pT sinDisRet(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo(
    redeclare final package Medium1=MediumS,
    redeclare final package Medium2=MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-200,196},{-180,216}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiComGen1(
    redeclare final package MediumSerHea_a=MediumS,
    redeclare final package MediumSer=MediumW,
    redeclare final package MediumBui=MediumW,
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    bui(
      final have_heaWat=true,
      final have_chiWat=true),
    ets(
      final typ=TypDisSys.CombinedGeneration1,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      final have_chiWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal,
      QChiWat_flow_nominal=QChiWat_flow_nominal))
    "Building and ETS component - Combined heating (steam) and cooling"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Fluid.Sources.MassFlowSource_T souDisSup1(
    redeclare final package Medium=MediumS,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));
  Fluid.Sources.Boundary_pT sinDisRet1(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo1(
    redeclare final package Medium1=MediumS,
    redeclare final package Medium2 = Media.Water,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-200,-24},{-180,-4}})));
  Fluid.Sources.MassFlowSource_T souDisSup2(
    redeclare final package Medium=MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Fluid.Sources.Boundary_pT sinDisRet2(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo2(
    redeclare final package Medium1=MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-160,-64},{-140,-44}})));
  Fluid.Sources.MassFlowSource_T souDisSup3(
    redeclare final package Medium=MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-240,90},{-220,110}})));
  Fluid.Sources.Boundary_pT sinDisRet3(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo3(
    redeclare final package Medium1=MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-200,76},{-180,96}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiCoo(
    redeclare final package MediumSer=MediumW,
    redeclare final package MediumBui=MediumW,
    nPorts_chiWat=1,
    bui(
      final have_chiWat=true),
    ets(
      final typ=TypDisSys.Cooling,
      final m_flow_nominal=m_flow_nominal,
      final have_chiWat=true,
      QChiWat_flow_nominal=QChiWat_flow_nominal))
    "Building and ETS component - Cooling only"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiComGen2to4(
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    bui(
      final have_heaWat=true,
      final have_chiWat=true),
    ets(
      final typ=TypDisSys.CombinedGeneration2to4,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      final have_chiWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal,
      QChiWat_flow_nominal=QChiWat_flow_nominal))
    "Building and ETS component - Combined heating and cooling"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.Sources.MassFlowSource_T souDisSup5(
    redeclare final package Medium = MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sources.Boundary_pT sinDisRet5(
    redeclare final package Medium = MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo5(
    redeclare final package Medium1 = MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-40,-24},{-20,-4}})));
  Fluid.Sources.MassFlowSource_T souDisSup6(
    redeclare final package Medium =MediumW,
    m_flow=m_flow_nominal,                   nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Fluid.Sources.Boundary_pT sinDisRet6(
    redeclare final package Medium = MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo6(
    redeclare final package Medium1 = MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{0,-64},{20,-44}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiHeaGen2to4(
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    bui(
      final have_heaWat=true),
    ets(
      final typ=TypDisSys.HeatingGeneration2to4,
      final m_flow_nominal= m_flow_nominal,
      final have_heaWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal))
    "Building and ETS component - Heating only"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));
  Fluid.Sources.MassFlowSource_T souDisSup7(
    redeclare final package Medium = MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Fluid.Sources.Boundary_pT sinDisRet7(
    redeclare final package Medium = MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo7(
    redeclare final package Medium1 = MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-40,196},{-20,216}})));
  Fluid.Sources.MassFlowSource_T souDisSup4(
    redeclare final package Medium = MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Fluid.Sources.Boundary_pT sinDisRet4(redeclare final package Medium = MediumW,
      nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo4(redeclare
      final package Medium1 = MediumW, final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{160,-24},{180,-4}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiComGen5(
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    bui(final have_heaWat=true, final have_chiWat=true),
    ets(
      final typ=TypDisSys.CombinedGeneration5,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      final have_chiWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal,
      QChiWat_flow_nominal=QChiWat_flow_nominal))
    "Building and ETS component - Combined heating and cooling (ambient)"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Fluid.Sources.MassFlowSource_T souDisSup8(
    redeclare final package Medium = MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  Fluid.Sources.Boundary_pT sinDisRet8(redeclare final package Medium = MediumW,
      nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo8(redeclare
      final package Medium1 = MediumW, final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-200,-184},{-180,-164}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiTesOutETS(
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    bui(final have_heaWat=true, final have_chiWat=true),
    ets(
      final typ=TypDisSys.CombinedGeneration5,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      final have_chiWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal,
      QChiWat_flow_nominal=QChiWat_flow_nominal,
      final have_fan=true,
      final have_pum=true,
      final have_eleHea=true,
      final have_eleCoo=true))
    "Building and ETS component - Testing ETS output connectors"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Fluid.Sources.MassFlowSource_T souDisSup9(
    redeclare final package Medium = MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Fluid.Sources.Boundary_pT sinDisRet9(redeclare final package Medium = MediumW,
      nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo9(redeclare
      final package Medium1 = MediumW, final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-40,-184},{-20,-164}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiTesOutETSBui(
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    bui(
      final have_heaWat=true,
      final have_chiWat=true,
      final have_fan=true,
      final have_pum=true,
      final have_eleHea=true,
      final have_eleCoo=true),
    ets(
      final typ=TypDisSys.CombinedGeneration5,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      final have_chiWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal,
      QChiWat_flow_nominal=QChiWat_flow_nominal,
      final have_fan=true,
      final have_pum=true,
      final have_eleHea=true,
      final have_eleCoo=true))
    "Building and ETS component - Testing ETS and building output connectors"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Fluid.Sources.MassFlowSource_T souDisSup10(
    redeclare final package Medium = MediumW,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{100,-170},{120,-150}})));
  Fluid.Sources.Boundary_pT sinDisRet10(redeclare final package Medium =
        MediumW, nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{100,-210},{120,-190}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo10(redeclare
      final package Medium1 = MediumW, final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{140,-184},{160,-164}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS buiTesFacMul(
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    facMul=2,
    bui(
      final have_heaWat=true,
      final have_chiWat=true,
      final have_fan=true,
      final have_pum=true,
      final have_eleHea=true,
      final have_eleCoo=true),
    ets(
      final typ=TypDisSys.CombinedGeneration5,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      final have_chiWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal,
      QChiWat_flow_nominal=QChiWat_flow_nominal,
      final have_fan=true,
      final have_pum=true,
      final have_eleHea=true,
      final have_eleCoo=true))
    "Building and ETS component - Testing scaling factor"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
equation
  connect(souDisSup.ports[1],senDifEntFlo.port_a1)
    annotation (Line(points={{-220,220},{-212,220},{-212,212},{-200,212}},color={0,127,255}));
  connect(senDifEntFlo.port_b2,sinDisRet.ports[1])
    annotation (Line(points={{-200,200},{-212,200},{-212,180},{-220,180}},color={0,127,255}));
  connect(souDisSup1.ports[1],senDifEntFlo1.port_a1)
    annotation (Line(points={{-220,0},{-212,0},{-212,-8},{-200,-8}},  color={0,127,255}));
  connect(senDifEntFlo1.port_b2,sinDisRet1.ports[1])
    annotation (Line(points={{-200,-20},{-212,-20},{-212,-40},{-220,-40}},
                                                                      color={0,127,255}));
  connect(souDisSup2.ports[1],senDifEntFlo2.port_a1)
    annotation (Line(points={{-180,-40},{-170,-40},{-170,-48},{-160,-48}},
                                                                    color={0,127,255}));
  connect(senDifEntFlo2.port_b2,sinDisRet2.ports[1])
    annotation (Line(points={{-160,-60},{-170,-60},{-170,-80},{-180,-80}},
                                                                    color={0,127,255}));
  connect(souDisSup3.ports[1],senDifEntFlo3.port_a1)
    annotation (Line(points={{-220,100},{-210,100},{-210,92},{-200,92}},color={0,127,255}));
  connect(sinDisRet3.ports[1],senDifEntFlo3.port_b2)
    annotation (Line(points={{-220,60},{-210,60},{-210,80},{-200,80}},color={0,127,255}));
  connect(senDifEntFlo.port_b1, buiHeaGen1.port_aSerHea) annotation (Line(
        points={{-180,212},{-170,212},{-170,216},{-160,216}}, color={0,127,255}));
  connect(senDifEntFlo.port_a2, buiHeaGen1.port_bSerHea) annotation (Line(
        points={{-180,200},{-120,200},{-120,216},{-140,216}}, color={0,127,255}));
  connect(senDifEntFlo1.port_b1, buiComGen1.port_aSerHea) annotation (Line(
        points={{-180,-8},{-170,-8},{-170,-4},{-160,-4}},
                                                        color={0,127,255}));
  connect(buiComGen1.port_bSerHea, senDifEntFlo1.port_a2) annotation (Line(
        points={{-140,-4},{-120,-4},{-120,-20},{-180,-20}},
                                                       color={0,127,255}));
  connect(senDifEntFlo2.port_b1, buiComGen1.port_aSerCoo) annotation (Line(
        points={{-140,-48},{-120,-48},{-120,-30},{-166,-30},{-166,-8},{-160,-8}},
                                                                       color={0,
          127,255}));
  connect(buiComGen1.port_bSerCoo, senDifEntFlo2.port_a2) annotation (Line(
        points={{-140,-8},{-100,-8},{-100,-60},{-140,-60}},
                                                      color={0,127,255}));
  connect(senDifEntFlo3.port_b1, buiCoo.port_aSerCoo)
    annotation (Line(points={{-180,92},{-160,92}}, color={0,127,255}));
  connect(buiCoo.port_bSerCoo, senDifEntFlo3.port_a2) annotation (Line(points={{
          -140,92},{-120,92},{-120,80},{-180,80}}, color={0,127,255}));
  connect(souDisSup5.ports[1],senDifEntFlo5.port_a1)
    annotation (Line(points={{-60,0},{-52,0},{-52,-8},{-40,-8}},      color={0,127,255}));
  connect(senDifEntFlo5.port_b2,sinDisRet5.ports[1])
    annotation (Line(points={{-40,-20},{-52,-20},{-52,-40},{-60,-40}},color={0,127,255}));
  connect(souDisSup6.ports[1],senDifEntFlo6.port_a1)
    annotation (Line(points={{-20,-40},{-10,-40},{-10,-48},{0,-48}},color={0,127,255}));
  connect(senDifEntFlo6.port_b2,sinDisRet6.ports[1])
    annotation (Line(points={{0,-60},{-10,-60},{-10,-80},{-20,-80}},color={0,127,255}));
  connect(senDifEntFlo5.port_b1, buiComGen2to4.port_aSerHea) annotation (Line(
        points={{-20,-8},{-10,-8},{-10,-4},{0,-4}}, color={0,127,255}));
  connect(buiComGen2to4.port_bSerHea, senDifEntFlo5.port_a2) annotation (Line(
        points={{20,-4},{40,-4},{40,-20},{-20,-20}}, color={0,127,255}));
  connect(senDifEntFlo6.port_b1, buiComGen2to4.port_aSerCoo) annotation (Line(
        points={{20,-48},{40,-48},{40,-30},{-6,-30},{-6,-8},{0,-8}}, color={0,127,
          255}));
  connect(buiComGen2to4.port_bSerCoo, senDifEntFlo6.port_a2) annotation (Line(
        points={{20,-8},{60,-8},{60,-60},{20,-60}}, color={0,127,255}));
  connect(souDisSup7.ports[1], senDifEntFlo7.port_a1) annotation (Line(points={{
          -60,220},{-52,220},{-52,212},{-40,212}}, color={0,127,255}));
  connect(senDifEntFlo7.port_b2, sinDisRet7.ports[1]) annotation (Line(points={{
          -40,200},{-52,200},{-52,180},{-60,180}}, color={0,127,255}));
  connect(senDifEntFlo7.port_b1, buiHeaGen2to4.port_aSerHea) annotation (Line(
        points={{-20,212},{-10,212},{-10,216},{0,216}}, color={0,127,255}));
  connect(senDifEntFlo7.port_a2, buiHeaGen2to4.port_bSerHea) annotation (Line(
        points={{-20,200},{40,200},{40,216},{20,216}}, color={0,127,255}));
  connect(souDisSup4.ports[1],senDifEntFlo4.port_a1)
    annotation (Line(points={{140,0},{150,0},{150,-8},{160,-8}},        color={0,127,255}));
  connect(sinDisRet4.ports[1],senDifEntFlo4.port_b2)
    annotation (Line(points={{140,-40},{150,-40},{150,-20},{160,-20}},color={0,127,255}));
  connect(senDifEntFlo4.port_b1,buiComGen5. port_aSerAmb) annotation (Line(
        points={{180,-8},{190,-8},{190,0},{200,0}},     color={0,127,255}));
  connect(buiComGen5.port_bSerAmb,senDifEntFlo4. port_a2) annotation (Line(
        points={{220,0},{240,0},{240,-20},{180,-20}},     color={0,127,255}));
  connect(souDisSup8.ports[1],senDifEntFlo8.port_a1)
    annotation (Line(points={{-220,-160},{-210,-160},{-210,-168},{-200,-168}},
                                                                        color={0,127,255}));
  connect(sinDisRet8.ports[1],senDifEntFlo8.port_b2)
    annotation (Line(points={{-220,-200},{-210,-200},{-210,-180},{-200,-180}},
                                                                      color={0,127,255}));
  connect(senDifEntFlo8.port_b1,buiTesOutETS. port_aSerAmb) annotation (Line(
        points={{-180,-168},{-170,-168},{-170,-160},{-160,-160}}, color={0,127,255}));
  connect(buiTesOutETS.port_bSerAmb,senDifEntFlo8. port_a2) annotation (Line(
        points={{-140,-160},{-120,-160},{-120,-180},{-180,-180}}, color={0,127,255}));
  connect(souDisSup9.ports[1],senDifEntFlo9.port_a1)
    annotation (Line(points={{-60,-160},{-52,-160},{-52,-168},{-40,-168}},
                                                                        color={0,127,255}));
  connect(sinDisRet9.ports[1],senDifEntFlo9.port_b2)
    annotation (Line(points={{-60,-200},{-52,-200},{-52,-180},{-40,-180}},
                                                                      color={0,127,255}));
  connect(senDifEntFlo9.port_b1,buiTesOutETSBui. port_aSerAmb) annotation (Line(
        points={{-20,-168},{-12,-168},{-12,-160},{0,-160}},  color={0,127,255}));
  connect(buiTesOutETSBui.port_bSerAmb,senDifEntFlo9. port_a2) annotation (Line(
        points={{20,-160},{40,-160},{40,-180},{-20,-180}}, color={0,127,255}));
  connect(souDisSup10.ports[1],senDifEntFlo10. port_a1) annotation (Line(points={{120,
          -160},{130,-160},{130,-168},{140,-168}},      color={0,127,255}));
  connect(sinDisRet10.ports[1],senDifEntFlo10. port_b2) annotation (Line(points={{120,
          -200},{130,-200},{130,-180},{140,-180}},      color={0,127,255}));
  connect(senDifEntFlo10.port_b1,buiTesFacMul. port_aSerAmb) annotation (Line(
        points={{160,-168},{170,-168},{170,-160},{180,-160}}, color={0,127,255}));
  connect(buiTesFacMul.port_bSerAmb,senDifEntFlo10. port_a2) annotation (Line(
        points={{200,-160},{220,-160},{220,-180},{160,-180}}, color={0,127,255}));
  annotation (
    experiment(
      Tolerance=1e-6,
      StopTime=1.0),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Validation/BuildingWithETS.mos"
      "Simulate and plot"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-260,-260},{260,260}})),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS</a>
for various types of district system.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2021, by Michael Wetter:<br/>
Changed steam medium.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2395\">#2395</a>.
</li>
<li>
December 14, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingWithETS;
