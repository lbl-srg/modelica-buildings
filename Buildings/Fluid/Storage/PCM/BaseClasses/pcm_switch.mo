within Buildings.Fluid.Storage.PCM.BaseClasses;
model pcm_switch
  extends partialUnitCellPhaseChangeTwoCircuit;

  parameter Boolean pcm_new = false annotation (Dialog(group="PCM"));

  HeatTransfer.Conduction.SingleLayer           pcm(
    stateAtSurface_b=false,
    material=PCM,
    A=A_pcm,
    T_a_start=TStart_pcm,
    T_b_start=TStart_pcm) if not pcm_new "Sodium acetate trihydrate energy storage material" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
  Modelica.Blocks.Sources.RealExpression USum(y=sum((pcm.u[i]*pcm.m[i]) for i in
            1:size(pcm.u, 1))) if not pcm_new
    annotation (Placement(transformation(extent={{-80,-2},{-100,18}})));
  Modelica.Blocks.Sources.RealExpression mSum(y=sum((pcm.m[i]) for i in 1:size(
        pcm.u, 1))) if not pcm_new
    annotation (Placement(transformation(extent={{-80,2},{-100,-18}})));
  slPCMlib.Components.SingleLayerSlPCMlib pcm_slPCMlib(
    A=A_pcm,
    thickness=PCM.x,
    redeclare package PCM = pcm_data,
    T_a_start=TStart_pcm,
    T_b_start=TStart_pcm) if pcm_new annotation (Placement(transformation(extent={{-10,-10},
            {10,10}}, rotation=90)));

  replaceable package pcm_data =
      slPCMlib.Media_generic.generic_7thOrderSmoothStep
         constrainedby slPCMlib.Interfaces.partialPCM
    annotation (choicesAllMatching=true, Dialog(enable=pcm_new, group="PCM"));
  Modelica.Blocks.Sources.RealExpression USum_slPCMlib(y=sum((pcm_slPCMlib.u[i]*pcm_slPCMlib.m[i])
        for i in 1:size(pcm_slPCMlib.u, 1))) if pcm_new
    annotation (Placement(transformation(extent={{80,-2},{100,18}})));
  Modelica.Blocks.Sources.RealExpression mSum_slPCMlib(y=sum((pcm_slPCMlib.m[i]) for i in
            1:size(pcm_slPCMlib.u, 1))) if pcm_new
    annotation (Placement(transformation(extent={{80,2},{100,-18}})));
equation
  connect(heaFloDom.port_b,pcm. port_b)
    annotation (Line(points={{-70,14},{-74,14},{-74,10},{-40,10}},
                                                          color={191,0,0}));
  connect(pcm.port_a,heaFloPro. port_b)
    annotation (Line(points={{-40,-10},{-58,-10}}, color={191,0,0}));
  connect(heaFloPro.port_b, pcm_slPCMlib.port_a)
    annotation (Line(points={{-58,-10},{0,-10}}, color={191,0,0}));
  connect(heaFloDom.port_b, pcm_slPCMlib.port_b) annotation (Line(points={{-70,14},
          {-74,14},{-74,10},{0,10}}, color={191,0,0}));
end pcm_switch;
