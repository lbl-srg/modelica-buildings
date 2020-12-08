within Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses;
model ETS
  "Dummy ETS model for validation purposes"
  extends Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS(
    nPorts_aHeaWat=nPorts_bHeaWat,
    nPorts_bHeaWat=nPorts_aHeaWat,
    nPorts_aChiWat=nPorts_bChiWat,
    nPorts_bChiWat=nPorts_aChiWat);
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPHea(
    k=1)
    annotation (Placement(transformation(extent={{260,50},{280,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPCoo(
    k=1)
    annotation (Placement(transformation(extent={{260,10},{280,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPFan(
    k=1)
    annotation (Placement(transformation(extent={{260,-30},{280,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPPum(
    k=1)
    annotation (Placement(transformation(extent={{260,-70},{280,-50}})));
  Fluid.Sources.Boundary_pT sinDisSup(
    redeclare final package Medium=Medium1,
    nPorts=1) if typ <> DHC.Types.DistrictSystemType.Cooling
    "Sink for district supply"
    annotation (Placement(transformation(extent={{-260,-230},{-280,-210}})));
  Fluid.Sources.MassFlowSource_T souDisRet(
    redeclare final package Medium=Medium1b,
    m_flow=m_flow_nominal,
    nPorts=1) if typ <> DHC.Types.DistrictSystemType.Cooling
    "Source for district return"
    annotation (Placement(transformation(extent={{260,-230},{280,-210}})));
equation
  connect(port_a1ChiWat,port_b1ChiWat)
    annotation (Line(points={{-300,-280},{0,-280},{0,-280},{300,-280}},color={0,127,255}));
  connect(ports_aHeaWat,ports_bHeaWat)
    annotation (Line(points={{-300,260},{300,260}},color={0,127,255}));
  connect(ports_aChiWat,ports_bChiWat)
    annotation (Line(points={{-300,200},{300,200}},color={0,127,255}));
  connect(souPCoo.y,PCoo)
    annotation (Line(points={{282,20},{320,20}},color={0,0,127}));
  connect(souPFan.y,PFan)
    annotation (Line(points={{282,-20},{320,-20}},color={0,0,127}));
  connect(souPPum.y,PPum)
    annotation (Line(points={{282,-60},{320,-60}},color={0,0,127}));
  connect(souPHea.y,PHea)
    annotation (Line(points={{282,60},{294,60},{294,60},{320,60}},color={0,0,127}));
  connect(port_a1,sinDisSup.ports[1])
    annotation (Line(points={{-300,-220},{-280,-220}},color={0,127,255}));
  connect(souDisRet.ports[1],port_b1)
    annotation (Line(points={{280,-220},{300,-220}},color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)));
end ETS;
