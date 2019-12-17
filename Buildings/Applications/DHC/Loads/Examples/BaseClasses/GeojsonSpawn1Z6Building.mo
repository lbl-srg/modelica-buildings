within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model GeojsonSpawn1Z6Building
  "Spawn building model based on Urbanopt GeoJSON export"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    final haveEleHeaCoo=false,
    final haveFanPum=true,
    final nLoa=6, final nPorts1=2);
  package Medium2 = Buildings.Media.Air "Medium model";
  parameter String idfPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago1.idf"
    "Path of the IDF file";
  parameter String weaPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nLoa](
    k=fill(20, nLoa)) "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nLoa]
    annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nLoa](
    k=fill(24, nLoa)) "Maximum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nLoa]
    annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-14,180},{6,200}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
    redeclare package Medium = Medium2,
    final nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Attic") "Thermal zone"
    annotation (Placement(transformation(extent={{24,84},{64,124}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
    redeclare package Medium = Medium2,
    final nPorts=2,
    zoneName="Core_ZN") "Thermal zone"
    annotation (Placement(transformation(extent={{24,40},{64,80}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
    redeclare package Medium = Medium2,
    final nPorts=2,
    zoneName="Perimeter_ZN_1") "Thermal zone"
    annotation (Placement(transformation(extent={{24,0},{64,40}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
    redeclare package Medium = Medium2,
    final nPorts=2,
    zoneName="Perimeter_ZN_2") "Thermal zone"
    annotation (Placement(transformation(extent={{24,-40},{64,0}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
    redeclare package Medium = Medium2,
    final nPorts=2,
    zoneName="Perimeter_ZN_3") "Thermal zone"
    annotation (Placement(transformation(extent={{24,-80},{64,-40}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
    redeclare package Medium = Medium2,
    final nPorts=2,
    zoneName="Perimeter_ZN_4") "Thermal zone"
    annotation (Placement(transformation(extent={{24,-120},{64,-80}})));
  inner Buildings.Experimental.EnergyPlus.Building building(
    idfName=Modelica.Utilities.Files.loadResource(idfPath),
    weaName=Modelica.Utilities.Files.loadResource(weaPath),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Building outer component"
    annotation (Placement(transformation(extent={{30,198},{52,218}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.Terminal4PipesFluidPorts
    terUni[nLoa](
    Q_flow_nominal={{50000,10000},{10000,10000},{10000,10000},{10000,10000},{
        10000,10000},{10000,10000}},
    each T_a2_nominal={293.15,297.15},
    each T_b1_nominal={disFloHea.T_b1_nominal,disFloCoo.T_b1_nominal},
    each T_a1_nominal={disFloHea.T_a1_nominal,disFloCoo.T_a1_nominal},
    each m_flow2_nominal={5,5},
    each dp2_nominal={100,100})
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    m_flow1_nominal=sum(terUni.m_flow1_nominal[1]),
    T_a1_nominal=313.15,
    T_b1_nominal=308.15,
    nLoa=nLoa)
    annotation (Placement(transformation(extent={{-238,-190},{-218,-170}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    m_flow1_nominal=sum(terUni.m_flow1_nominal[2]),
    T_a1_nominal=280.15,
    T_b1_nominal=285.15,
    nLoa=nLoa)
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=nLoa)
    annotation (Placement(transformation(extent={{220,220},{240,240}})));
equation
  connect(maxTSet.y,from_degC2.u)
    annotation (Line(points={{-278,220},{-262,220}}, color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-278,260},{-262,260}}, color={0,0,127}));
  connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
      points={{-39,230},{-20,230},{-20,197},{-16,197}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1])
    annotation (Line(
      points={{-39,190},{-50,190},{-44,190},{-16,190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-16,183},{-20,183},{-20,150},{-39,150}}, color={0,0,127}));
  connect(multiplex3_1.y,znAttic.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,114},{22,114}}, color={0,0,127}));
  connect(multiplex3_1.y,znCore_ZN.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,70},{22,70}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_1.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,30},{22,30}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_2.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,-10},{22,-10}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_3.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,-50},{22,-50}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_4.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,-90},{22,-90}}, color={0,0,127}));
  connect(ports_a1[1], disFloHea.port_a)
    annotation (Line(points={{-300,-20},{-280,-20},{-280,-180},{-238,-180}},
                                         color={0,127,255}));
  connect(disFloHea.port_b, ports_b1[1])
    annotation (Line(points={{-218,-180},{260,-180},{260,-20},{300,-20}},
                                      color={0,127,255}));
  connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
          20},{-280,-220},{-180,-220}}, color={0,127,255}));
  connect(disFloHea.ports_b1, terUni.ports_a1[1]) annotation (Line(points={{-238,
          -174},{-260,-174},{-260,-8},{-80,-8}},     color={0,127,255}));
  connect(terUni.ports_b1[1], disFloHea.ports_a1) annotation (Line(points={{-60,-8},
          {-40,-8},{-40,-174},{-218,-174}},         color={0,127,255}));
  connect(disFloCoo.ports_b1, terUni.ports_a1[2]) annotation (Line(points={{-180,
          -214},{-200,-214},{-200,-4},{-80,-4}},     color={0,127,255}));
  connect(terUni.ports_b1[2], disFloCoo.ports_a1) annotation (Line(points={{-60,-4},
          {-20,-4},{-20,-214},{-160,-214}},         color={0,127,255}));
  connect(from_degC1.y, terUni.TSetHea[1]) annotation (Line(points={{-238,260},
          {-160,260},{-160,6.66667},{-80.8333,6.66667}}, color={0,0,127}));
  connect(from_degC2.y, terUni.TSetHea[2]) annotation (Line(points={{-238,220},
          {-160,220},{-160,6.66667},{-80.8333,6.66667}}, color={0,0,127}));
  connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-160,-220},{280,
          -220},{280,20},{300,20}}, color={0,127,255}));
  connect(znAttic.ports[1], terUni[1].port_a2) annotation (Line(points={{42,84.8},
          {0,84.8},{0,9.16667},{-60,9.16667}},
                                         color={0,127,255}));
  connect(terUni[1].port_b2, znAttic.ports[2]) annotation (Line(points={{-80,
          9.16667},{-100,9.16667},{-100,84.8},{46,84.8}},
                                                color={0,127,255}));
  connect(znCore_ZN.ports[1], terUni[2].port_a2) annotation (Line(points={{42,40.8},
          {-8,40.8},{-8,9.16667},{-60,9.16667}},
                                           color={0,127,255}));
  connect(terUni[2].port_b2, znCore_ZN.ports[2]) annotation (Line(points={{-80,
          9.16667},{-16,9.16667},{-16,40.8},{46,40.8}},
                                              color={0,127,255}));
  connect(znPerimeter_ZN_1.ports[1], terUni[3].port_a2) annotation (Line(points={{42,0.8},
          {-8,0.8},{-8,9.16667},{-60,9.16667}},
                                    color={0,127,255}));
  connect(terUni[3].port_b2, znPerimeter_ZN_1.ports[2]) annotation (Line(points={{-80,
          9.16667},{-16,9.16667},{-16,0.8},{46,0.8}},
                                      color={0,127,255}));
  connect(znPerimeter_ZN_2.ports[1], terUni[4].port_a2) annotation (Line(points={{42,
          -39.2},{-8,-39.2},{-8,9.16667},{-60,9.16667}},
                                                      color={0,127,255}));
  connect(terUni[4].port_b2, znPerimeter_ZN_2.ports[2]) annotation (Line(points={{-80,
          9.16667},{-16,9.16667},{-16,-39.2},{46,-39.2}},
                                          color={0,127,255}));
  connect(znPerimeter_ZN_3.ports[1], terUni[5].port_a2) annotation (Line(points={{42,
          -79.2},{-8,-79.2},{-8,9.16667},{-60,9.16667}},
                                                      color={0,127,255}));
  connect(terUni[5].port_b2, znPerimeter_ZN_3.ports[2]) annotation (Line(points={{-80,
          9.16667},{-18,9.16667},{-18,-79.2},{46,-79.2}},
                                          color={0,127,255}));
  connect(znPerimeter_ZN_4.ports[1], terUni[6].port_a2) annotation (Line(points={{42,
          -119.2},{42,6.4},{-60,6.4},{-60,9.16667}},
                                               color={0,127,255}));
  connect(terUni[6].port_b2, znPerimeter_ZN_4.ports[2]) annotation (Line(points={{-80,
          9.16667},{-20,9.16667},{-20,-119.2},{46,-119.2}},
                                            color={0,127,255}));
  connect(PFan, mulSum.y) annotation (Line(points={{320,120},{282,120},{282,230},
          {242,230}}, color={0,0,127}));
  connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{-59.1667,
          7.5},{160.5,7.5},{160.5,280},{320,280}}, color={0,0,127}));
  connect(terUni.PFan, mulSum.u) annotation (Line(points={{-59.1667,0.833333},{
          200,0.833333},{200,230},{218,230}}, color={0,0,127}));
  connect(terUni.m1ReqCoo_flow[1], disFloHea.m_flow1Req_i) annotation (Line(
        points={{-59,5.5},{-59,-90.5},{-239,-90.5},{-239,-188}}, color={0,0,127}));
  connect(terUni.m1ReqCoo_flow[2], disFloCoo.m_flow1Req_i) annotation (Line(
        points={{-59,6.5},{-59,-109.5},{-181,-109.5},{-181,-228}}, color={0,0,
          127}));
  annotation (
  Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
  Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end GeojsonSpawn1Z6Building;
