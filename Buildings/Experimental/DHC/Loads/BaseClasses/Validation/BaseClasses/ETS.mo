within Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses;
model ETS
  "Dummy ETS model for validation purposes"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant souPHea(
    k=1)
    annotation (Placement(transformation(extent={{260,50},{280,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant souPCoo(
    k=1)
    annotation (Placement(transformation(extent={{260,10},{280,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant souPFan(
    k=1)
    annotation (Placement(transformation(extent={{260,-30},{280,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant souPPum(
    k=1)
    annotation (Placement(transformation(extent={{260,-70},{280,-50}})));
  Fluid.Sources.Boundary_pT sinSerAmbSup(
    redeclare final package Medium = MediumSer,
    nPorts=1) if typ == Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5
    "Sink for service supply"
    annotation (Placement(transformation(extent={{-260,-210},{-280,-190}})));
  Fluid.Sources.MassFlowSource_T souSerAmbRet(
    redeclare final package Medium = MediumSer,
    m_flow=m_flow_nominal,
    nPorts=1) if typ == Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5
    "Source for service return"
    annotation (Placement(transformation(extent={{260,-210},{280,-190}})));
  Fluid.Sources.Boundary_pT sinSerHeaSup(
    redeclare final package Medium = MediumSerHea_a,
    nPorts=1) if typ <> Buildings.Experimental.DHC.Types.DistrictSystemType.Cooling and
    typ <> Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5
    "Sink for service supply"
    annotation (Placement(transformation(extent={{-260,-250},{-280,-230}})));
  Fluid.Sources.MassFlowSource_T souSerHeaReat(
    redeclare final package Medium = MediumSer,
    m_flow=m_flow_nominal,
    nPorts=1) if typ <> Buildings.Experimental.DHC.Types.DistrictSystemType.Cooling and
    typ <> Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5
    "Source for service return"
    annotation (Placement(transformation(extent={{260,-250},{280,-230}})));
  Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare final package Medium =MediumBui,
    nPorts=nPorts_aHeaWat) if have_heaWat
    "Sink for heating water"
    annotation (Placement(transformation(extent={{-260,250},{-280,270}})));
  Fluid.Sources.Boundary_pT sinChiWat(
    redeclare final package Medium = MediumBui,
    nPorts=nPorts_aChiWat) if have_chiWat
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-260,190},{-280,210}})));
  Fluid.Sources.MassFlowSource_T souHeaWat(
    redeclare final package Medium = MediumBui,
    m_flow=m_flow_nominal,
    nPorts=nPorts_bHeaWat) if have_heaWat
    "Source for heating water"
    annotation (Placement(transformation(extent={{258,250},{278,270}})));
  Fluid.Sources.MassFlowSource_T souChiWat(
    redeclare final package Medium = MediumBui,
    m_flow=m_flow_nominal,
    nPorts=nPorts_bChiWat) if have_chiWat
    "Source for chilled water"
    annotation (Placement(transformation(extent={{260,190},{280,210}})));
equation
  connect(port_aSerCoo, port_bSerCoo) annotation (Line(points={{-300,-280},{0,
          -280},{0,-280},{300,-280}}, color={0,127,255}));
  connect(souPCoo.y,PCoo)
    annotation (Line(points={{282,20},{320,20}},color={0,0,127}));
  connect(souPFan.y,PFan)
    annotation (Line(points={{282,-20},{320,-20}},color={0,0,127}));
  connect(souPPum.y,PPum)
    annotation (Line(points={{282,-60},{320,-60}},color={0,0,127}));
  connect(souPHea.y,PHea)
    annotation (Line(points={{282,60},{294,60},{294,60},{320,60}},color={0,0,127}));
  connect(port_aSerAmb, sinSerAmbSup.ports[1])
    annotation (Line(points={{-300,-200},{-280,-200}}, color={0,127,255}));
  connect(souSerAmbRet.ports[1], port_bSerAmb)
    annotation (Line(points={{280,-200},{300,-200}}, color={0,127,255}));
  connect(port_aSerHea, sinSerHeaSup.ports[1])
    annotation (Line(points={{-300,-240},{-280,-240}}, color={0,127,255}));
  connect(souSerHeaReat.ports[1], port_bSerHea)
    annotation (Line(points={{280,-240},{300,-240}}, color={0,127,255}));
  connect(ports_aChiWat, sinChiWat.ports)
    annotation (Line(points={{-300,200},{-280,200}}, color={0,127,255}));
  connect(ports_aHeaWat, sinHeaWat.ports)
    annotation (Line(points={{-300,260},{-280,260}}, color={0,127,255}));
  connect(souChiWat.ports, ports_bChiWat)
    annotation (Line(points={{280,200},{300,200}}, color={0,127,255}));
  connect(souHeaWat.ports, ports_bHeaWat)
    annotation (Line(points={{278,260},{300,260}}, color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a minimum example of a class extending
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS\">
Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS</a>
developed for testing purposes only.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ETS;
