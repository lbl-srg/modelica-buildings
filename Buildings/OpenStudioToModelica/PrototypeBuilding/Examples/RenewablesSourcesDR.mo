within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model RenewablesSourcesDR
  extends RenewableSources(
    bui1(useDeltaTSP=true),
    bui2(useDeltaTSP=true),
    bui3(useDeltaTSP=true),
    bui4(useDeltaTSP=true),
    bui5(useDeltaTSP=true),
    bui6(useDeltaTSP=true),
    bui7(useDeltaTSP=true));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    k=1,
    T=10,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0)
    annotation (Placement(transformation(extent={{160,-50},{140,-30}})));
  Modelica.Blocks.Sources.Constant const(k=1.05)
    annotation (Placement(transformation(extent={{120,-30},{100,-10}})));
  Controls.Continuous.LimPID conPID(
    k=10,
    Ti=10,
    yMax=2,
    yMin=0,
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    limitsAtInit=true,
    xi_start=0)
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
equation
  connect(sen2.V, firstOrder.u) annotation (Line(points={{177,-13},{186,-13},{
          186,-40},{162,-40}}, color={0,0,127}));
  connect(firstOrder.y, conPID.u_m) annotation (Line(points={{139,-40},{120,-40},
          {120,-60},{70,-60},{70,-52}}, color={0,0,127}));
  connect(const.y, conPID.u_s) annotation (Line(points={{99,-20},{92,-20},{92,
          -40},{82,-40}}, color={0,0,127}));
  connect(conPID.y, bui1.dTSp) annotation (Line(points={{59,-40},{-24,-40},{
          -112,-40},{-112,70},{-24,70},{-24,52},{-30,52}}, color={0,0,127}));
  connect(conPID.y, bui2.dTSp) annotation (Line(points={{59,-40},{-26,-40},{
          -112,-40},{-112,70},{16,70},{16,52},{10,52}}, color={0,0,127}));
  connect(conPID.y, bui3.dTSp) annotation (Line(points={{59,-40},{-26,-40},{
          -112,-40},{-112,70},{56,70},{56,52},{50,52}}, color={0,0,127}));
  connect(conPID.y, bui4.dTSp) annotation (Line(points={{59,-40},{-26,-40},{
          -112,-40},{-112,70},{96,70},{96,52},{90,52}}, color={0,0,127}));
  connect(conPID.y, bui5.dTSp) annotation (Line(points={{59,-40},{-28,-40},{
          -112,-40},{-112,70},{136,70},{136,52},{130,52}}, color={0,0,127}));
  connect(conPID.y, bui6.dTSp) annotation (Line(points={{59,-40},{-28,-40},{
          -112,-40},{-112,70},{176,70},{176,52},{170,52}}, color={0,0,127}));
  connect(conPID.y, bui7.dTSp) annotation (Line(points={{59,-40},{-26,-40},{
          -112,-40},{-112,70},{216,70},{216,52},{210,52}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{380,100}})));
end RenewablesSourcesDR;
