within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Examples;
model CDU_epsNTU "Example model of a CDU with varying load on the IT side"
  extends Modelica.Icons.Example;
  Controls.OBC.CDL.Reals.Sources.Pulse           uti(
    amplitude=0.4,
    width=2/5,
    period=5,
    shift=0.2,
    offset=0.62)
    "Utilization of hardware"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Racks.ColdPlateR_P                                                 rac(
    redeclare package Medium = Medium,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    datTheRes=datTheRes,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                         "Rack with cold plate heat exchangers"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Fluid.Sources.Boundary_pT           bou(redeclare package Medium = Medium,
      nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
  Fluid.Sensors.TemperatureTwoPort senTOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Outlet temperature"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  parameter Racks.Data.OCP_1kW_OAM_PG25
                                  datTheRes "Thermal resistance data"
    annotation (Placement(transformation(extent={{60,-34},{80,-14}})));
  Buildings.Applications.DataCenters.LiquidCooled.CDUs.CDU_epsNTU cdu
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Sources.Boundary_pT sou(redeclare package Medium = Medium, nPorts=1)
    "Pressure boundary condition" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,70})));
equation
  connect(uti.y, rac.u) annotation (Line(points={{-38,-50},{-20,-50},{-20,-54},
          {-1,-54}}, color={0,0,127}));
end CDU_epsNTU;
