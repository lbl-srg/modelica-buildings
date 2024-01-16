within Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle;
model ConstantCarnotEffectiveness "Carnot EER with a constant Carnot effectiveness"
  extends
    Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
      useInChi=true,
      PEle_nominal=-QCoo_flow_nominal/EER_nominal/y_nominal,
      QCooNoSca_flow_nominal=QCoo_flow_nominal,
      datSou="ConstantCarnotEffectiveness");
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialCarnot(
     TAppCon_nominal=if cpCon < 1500 then 5 else 2,
     TAppEva_nominal=if cpEva < 1500 then 5 else 2,
     final useForChi=true,
     final QEva_flow_nominal=QCoo_flow_nominal,
     final QCon_flow_nominal=PEle_nominal-QCoo_flow_nominal,
     constPEle(final k=PEle_nominal),
    proQUse_flow(nu=4));
  parameter Real EER_nominal(
    min=0,
    final unit="1") = etaCarnot_nominal*(TEva_nominal - TAppEva_nominal)/(
    TCon_nominal + TAppCon_nominal - (TEva_nominal - TAppEva_nominal))
    "Nominal EER";

  Modelica.Blocks.Sources.Constant constNegOne(final k=-1)
    "Negative one to negative evaporator heat flow rate" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,30})));
equation
  connect(swiQUse.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-50,30},
          {0,30},{0,120},{1,120}},      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(swiPEle.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-36},{64,
          -36},{64,-78}}, color={0,0,127}));
  connect(swiPEle.y, PEle) annotation (Line(points={{50,-1},{50,-8},{0,-8},{0,
          -130}},
        color={0,0,127}));
  connect(swiPEle.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,30},{
          0,30},{0,120},{1,120}},
                           color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasThrYSet.u, sigBus.ySet) annotation (Line(points={{18,70},{1,70},{1,
          120}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  if useInChi then
    connect(pasThrTCon.u, sigBus.TConOutMea) annotation (Line(points={{-30,102},{
            -30,120},{1,120}},
                           color={0,0,127}));
    connect(pasThrTEva.u, sigBus.TEvaOutMea) annotation (Line(points={{-70,102},{
            -70,120},{1,120}},
                           color={0,0,127}));
  else
    connect(pasThrTCon.u, sigBus.TEvaOutMea) annotation (Line(points={{-30,102},{
            -30,120},{1,120}},
                           color={0,0,127}));
    connect(pasThrTEva.u, sigBus.TConOutMea) annotation (Line(points={{-70,102},{
            -70,120},{1,120}},
                           color={0,0,127}));
  end if;
  connect(swiQUse.y, proRedQEva.u2) annotation (Line(points={{-50,-1},{-50,-30},{
          -24,-30},{-24,-78}},  color={0,0,127}));
  connect(calEER.PEle, swiPEle.y) annotation (Line(points={{-88,-86},{-82,-86},{
          -82,-66},{0,-66},{0,-8},{50,-8},{50,-1}}, color={0,0,127}));
  connect(constNegOne.y, proQUse_flow.u[4]) annotation (Line(points={{-79,30},{
          -68,30},{-68,70},{-50,70},{-50,60}}, color={0,0,127}));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model uses a constant Carnot effectiveness approach
  to compute the efficiency of the chiller.
</p>
<p>
  <code>PEle_nominal</code> is computed from the provided
  <code>QCoo_flow_nominal</code> and other nominal conditions.
  <code>PEle_nominal</code> stays constant over all boundary conditions
  and is used to calculate <code>PEle</code> by multiplying it with the
  relative compressor speed.
  <code>QEva_flow</code> is computed using the Carnot approach:
</p>
<p>
  <code>
    QEva_flow = PEle_nominal * etaCarnot_nominal * ySet *
    (TEvaOut - TAppEva) /
    (TConOut + TAppCon - (TEvaOut - TAppEva))
  </code>
</p>
<p>
  <code>
    PEle = PEle_nominal * ySet
  </code>
</p>
<p>
  These equations follow the same methods used in
  <a href=\"modelica://Buildings.Fluid.Chillers.Carnot_y\">
  Buildings.Fluid.Chillers.Carnot_y</a>
  Similarly, the variables <code>TAppCon</code> and
  <code>TAppEva</code> define the approach (pinch) temperature differences.
</p>
<p>
  The approach temperatures
  are calculated using the following equation:
</p>
<p>
  <code>
  TApp = TApp_nominal * Q_flow / Q_flow_nominal
  </code>
</p>
<p>
  This introduces nonlinear equations to the model, which
  can lead to solver issues for reversible operation.
  You can use the nominal values as a constant by
  enabling <code>use_constAppTem</code>
</p>
</html>"), Icon(graphics={Text(
          extent={{-78,68},{74,-78}},
          textColor={0,0,127},
          textString="Carnot")}));
end ConstantCarnotEffectiveness;
