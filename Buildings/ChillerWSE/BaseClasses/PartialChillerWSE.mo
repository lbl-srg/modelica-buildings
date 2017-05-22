within Buildings.ChillerWSE.BaseClasses;
model PartialChillerWSE
  "Partial model that contains chillers and WSE without connected configurations"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSEFourPortInterface;
  extends Buildings.ChillerWSE.BaseClasses.FourPortResistanceChillerWSE(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);

  parameter integer nChi "Number of identical chillers";

  Buildings.ChillerWSE.ElectricChilerParallel chiPar(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final m1_flow_nominal=m1Chiller_flow_nominal,
    final m2_flow_nominal=m2Chiller_flow_nominal,
    final dp1_nominal=dp1Chiller_nominal,
    final dp2_nominal=dp2Chiller_nominal,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    n=nChi)
     "Identical chillers"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.ChillerWSE.WSE wse(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1WSE_flow_nominal,
    final m2_flow_nominal=m2WSE_flow_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final dp1_nominal=dp1WSE_nominal,
    final dp2_nominal=dp2WSE_nominal,
    final from_dp1=from_dp1,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2)
    "Water Side Economizer"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Interfaces.BooleanInput on[nChi + 1]
    "Set to true to enable equipment, or false to disable equipment"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
equation
  connect(chiPar.on, on) annotation (Line(points={{-42,4},{-72,4},{-72,40},{-120,
          40}}, color={255,0,255}));
  connect(on, wse.on) annotation (Line(points={{-120,40},{0,40},{0,4},{18,4}},
        color={255,0,255}));
  connect(chiPar.TSet, TSet) annotation (Line(points={{-42,-4},{-70,-4},{-70,-20},
          {-120,-20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialChillerWSE;
