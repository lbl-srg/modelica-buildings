within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Networks;
model UnidirectionalParallel
  "Hydraulic network for unidirectional parallel DHC system"
  extends BaseClasses.PartialUnidirectionalParallel(
    redeclare BaseClasses.ConnectionParallel con[nCon](
      redeclare each final package Medium=Medium,
      final mDis_flow_nominal=mDis_flow_nominal,
      final mCon_flow_nominal=mCon_flow_nominal,
      each final allowFlowReversal=allowFlowReversal,
      lDis=lDis, lCon=lCon, dhDis=dhDis, dhCon=dhCon),
    redeclare BaseClasses.PipeDistribution pipEnd(
      redeclare final package Medium=Medium,
      final m_flow_nominal=mEnd_flow_nominal,
      final allowFlowReversal=allowFlowReversal,
      dh=dhEnd, length=2*lEnd));
  parameter Modelica.SIunits.Length lDis[nCon]
    "Length of the distribution pipe before each connection (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lCon[nCon]
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lEnd = 0
    "Length of the end of the distribution line (supply only, not counting return line)";
  parameter Modelica.SIunits.Length dhDis[nCon]
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length dhCon[nCon]
    "Hydraulic diameter of each connection pipe";
  parameter Modelica.SIunits.Length dhEnd = dhDis[nCon]
    "Hydraulic diameter of the end of the distribution line";
end UnidirectionalParallel;
