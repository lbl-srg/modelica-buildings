within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle;
model ConstantCarnotEffectiveness "Carnot COP with a constant Carnot effectiveness"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
      useInHeaPum=true,
      PEle_nominal=QHea_flow_nominal / COP_nominal,
      devIde="ConstantCarnotEffectiveness");
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialCarnot(
     TAppCon_nominal=if cpCon < 1500 then 5 else 2,
     TAppEva_nominal=if cpEva < 1500 then 5 else 2,
     final useForChi=false,
     final QEva_flow_nominal=PEle_nominal-QHea_flow_nominal,
     final QCon_flow_nominal=QHea_flow_nominal,
     constPEle(final k=PEle_nominal));
  parameter Real COP_nominal(
    min=0,
    final unit="1") = etaCarnot_nominal*(TCon_nominal + TAppCon_nominal)/(
    TCon_nominal + TAppCon_nominal - (TEva_nominal - TAppEva_nominal))
    "Nominal coefficient of performance";
equation

  connect(pasThrYMea.u, sigBus.yMea) annotation (Line(points={{18,70},{0,70},{0,
          118},{2,118},{2,120},{1,120}},
                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  if useInHeaPum then
    connect(pasThrTCon.u, sigBus.TConOutMea) annotation (Line(points={{-30,102},{
            -30,120},{1,120}},
                           color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(pasThrTEva.u, sigBus.TEvaOutMea) annotation (Line(points={{-70,102},{
            -70,120},{1,120}},
                           color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  else
    connect(pasThrTCon.u, sigBus.TEvaOutMea) annotation (Line(points={{-30,102},{
            -30,120},{1,120}},
                           color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(pasThrTEva.u, sigBus.TConOutMea) annotation (Line(points={{-70,102},{
            -70,120},{1,120}},
                           color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  end if;
  connect(swiPEle.y, redQCon.u2) annotation (Line(points={{50,-1},{50,-26},{62,
          -26},{62,-78},{64,-78}}, color={0,0,127}));
  connect(swiPEle.y, PEle) annotation (Line(points={{50,-1},{50,-92},{0,-92},{0,
          -130}}, color={0,0,127}));
  connect(swiQUse.u2, sigBus.onOffMea) annotation (Line(points={{-50,22},{-50,30},
          {0,30},{0,122},{1,122},{1,120}},
                               color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiPEle.u2, sigBus.onOffMea) annotation (Line(points={{50,22},{50,46},{
          0,46},{0,118},{2,118},{2,120},{1,120}},
                           color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiPEle.y, feeHeaFloEva.u1) annotation (Line(points={{50,-1},{50,-24},{
          -90,-24},{-90,-10},{-78,-10}}, color={0,0,127}));
  connect(feeHeaFloEva.u2, swiQUse.y)
    annotation (Line(points={{-70,-18},{-50,-18},{-50,-1}}, color={0,0,127}));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model uses a constant Carnot effectiveness
  to compute the efficiency of the heat pump.
</p>
<p>
  <code>PEle_nominal</code> is computed from the provided
  <code>QHea_flow_nominal</code> and other nominal conditions.
  <code>PEle_nominal</code> stays constant over all boundary conditions
  and is used to calculate <code>PEle</code> by multiplying it with the
  relative compressor speed.
  <code>QCon_flow</code> is computed using the Carnot approach:
</p>
<p>
  <code>
    QCon_flow = PEle_nominal * etaCarnot_nominal * yMea *
    (TConOut + TAppCon) /
    (TConOut + TAppCon - (TEvaOut - TAppEva))
  </code>
</p>
<p>
  <code>
    PEle = PEle_nominal * yMea
  </code>
</p>
<p>
  This equations follows the Carnot approach of the Buildings library:
  <a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_y\">
  Buildings.Fluid.HeatPumps.Carnot_y</a>
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
  You can fix the approach temperature at the nominal value by
  setting <code>use_constAppTem</code>
</p>
</html>"), Icon(graphics={Text(
          extent={{-78,80},{74,-66}},
          textColor={0,0,127},
          textString="Carnot")}));
end ConstantCarnotEffectiveness;
