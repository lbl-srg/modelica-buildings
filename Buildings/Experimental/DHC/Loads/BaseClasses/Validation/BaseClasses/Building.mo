within Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses;
model Building
  "Dummy building model for validation purposes"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding(
    nPorts_aHeaWat=nPorts_bHeaWat,
    nPorts_bHeaWat=nPorts_aHeaWat,
    nPorts_aChiWat=nPorts_bChiWat,
    nPorts_bChiWat=nPorts_aChiWat);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPHea(
    k=1)
    annotation (Placement(transformation(extent={{260,190},{280,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPCoo(
    k=1)
    annotation (Placement(transformation(extent={{260,150},{280,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPFan(
    k=1)
    annotation (Placement(transformation(extent={{260,110},{280,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souPPum(
    k=1)
    annotation (Placement(transformation(extent={{260,70},{280,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souQHea_flow(
    k=1)
    annotation (Placement(transformation(extent={{260,270},{280,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant souQCoo_flow(
    k=1)
    annotation (Placement(transformation(extent={{260,230},{280,250}})));
equation
  connect(ports_aHeaWat,ports_bHeaWat)
    annotation (Line(points={{-300,-60},{0,-60},{0,-60},{300,-60}},color={0,127,255}));
  connect(ports_aChiWat,ports_bChiWat)
    annotation (Line(points={{-300,-260},{-2,-260},{-2,-260},{300,-260}},color={0,127,255}));
  connect(souPCoo.y,PCoo)
    annotation (Line(points={{282,160},{320,160}},color={0,0,127}));
  connect(souPFan.y,PFan)
    annotation (Line(points={{282,120},{320,120}},color={0,0,127}));
  connect(souPPum.y,PPum)
    annotation (Line(points={{282,80},{320,80}},color={0,0,127}));
  connect(souPHea.y,PHea)
    annotation (Line(points={{282,200},{320,200}},color={0,0,127}));
  connect(souQCoo_flow.y,QCoo_flow)
    annotation (Line(points={{282,240},{296,240},{296,240},{320,240}},color={0,0,127}));
  connect(souQHea_flow.y,QHea_flow)
    annotation (Line(points={{282,280},{320,280}},color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)));
end Building;
