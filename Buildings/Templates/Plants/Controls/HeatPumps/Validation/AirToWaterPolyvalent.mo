within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model AirToWaterPolyvalent
  "Validation model for polyvalent heat pump plant controller"
  extends Buildings.Templates.Plants.Controls.HeatPumps.Validation.AirToWater(
    ctl(
      have_heaWat=true,
      have_chiWat=true,
      have_hrc_select=false,
      have_valHpInlIso=false,
      have_valHpOutIso=false,
      have_pumChiWatPriDed_select=true,
      have_pumPriHdr=false,
      is_priOnl=false,
      have_pumHeaWatPriVar_select=false,
      have_pumChiWatPriVar_select=false,
      have_senVHeaWatPri_select=false,
      have_senVChiWatPri_select=false,
      have_senTHeaWatPriRet_select=false,
      have_senTChiWatPriRet_select=false,
      nHp=2,
      nHpShc=1,
      nPumChiWatPri=ctl.nHp,
      have_senDpHeaWatRemWir=false,
      nSenDpHeaWatRem=1,
      have_senDpChiWatRemWir=false,
      nSenDpChiWatRem=1,
      THeaWatSupSet_min=298.15,
      VHeaWatHp_flow_nominal=1.1*fill(VHeaWat_flow_nominal/ctl.nHpTot, ctl.nHpTot),
      VHeaWatHp_flow_min=0.6*ctl.VHeaWatHp_flow_nominal,
      capHeaHp_nominal=fill(350E3, ctl.nHpTot),
      dpHeaWatRemSet_max={5E4},
      TChiWatSupSet_max=288.15,
      VChiWatHp_flow_nominal=1.1*fill(VChiWat_flow_nominal/ctl.nHpTot, ctl.nHpTot),
      VChiWatHp_flow_min=0.6*ctl.VChiWatHp_flow_nominal,
      capCooHp_nominal=fill(350E3, ctl.nHpTot),
      yPumHeaWatPriSet=0.8,
      yPumChiWatPriSet=0.7,
      dpChiWatRemSet_max={5E4},
      idxEquAlt={1,2},
      TChiWatSupHrc_min=277.15,
      THeaWatSupHrc_max=333.15,
      COPHeaHrc_nominal=2.8,
      capCooHrc_min=ctl.capHeaHrc_min *(1 - 1 / ctl.COPHeaHrc_nominal),
      capHeaHrc_min=0.3 * 0.5 * sum(ctl.capHeaHp_nominal)),
    break y1Hrc_actual,
    break THeaWatRetUpsHrc,
    break TChiWatRetUpsHrc,
    break dTChiWatUpsHrc,
    break dTHeaWatUpsHrc,
    break connect(dpChiWatRem.y, ctl.dpChiWatRem),
    break connect(dpHeaWatRem.y, ctl.dpHeaWatRem),
    break connect(TChiWatRet.y, ctl.TChiWatSecRet),
    break connect(THeaWatRet.y, ctl.THeaWatSecRet),
    break connect(VChiWat_flow.y, ctl.VChiWatPri_flow),
    break connect(VHeaWat_flow.y, ctl.VHeaWatPri_flow));
  Buildings.Controls.OBC.CDL.Logical.Or or2[ctl.nHpShc]
    "Combine enable signals for SHC enable signals in cooling and heating mode"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
protected
  Components.Controls.StatusEmulator y1PumChiWatPriFouPip_actual1[1]
                                                 "Primary CHW pump status"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Components.Controls.StatusEmulator y1PumHeaWatPriFouPip_actual1[1]
                                                 "Primary HW pump status"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Components.Controls.StatusEmulator y1HpShc_actual1[ctl.nHpShc]
    "SHC-HP status"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
equation
  connect(ctl.y1PumHeaWatPriShc, y1PumHeaWatPriFouPip_actual1.y1) annotation (
      Line(points={{72,-25},{88,-25},{88,-50},{98,-50}}, color={255,0,255}));
  connect(ctl.y1PumChiWatPriShc, y1PumChiWatPriFouPip_actual1.y1) annotation (
      Line(points={{72,-27},{86,-27},{86,-80},{98,-80}}, color={255,0,255}));
  connect(y1PumHeaWatPriFouPip_actual1.y1_actual, ctl.u1PumHeaWatPriShc_actual)
    annotation (Line(points={{122,-50},{172,-50},{172,90},{16,90},{16,38},{28,38}},
        color={255,0,255}));
  connect(y1PumChiWatPriFouPip_actual1.y1_actual, ctl.u1PumChiWatPriShc_actual)
    annotation (Line(points={{122,-80},{174,-80},{174,94},{14,94},{14,36},{28,36}},
        color={255,0,255}));
  connect(ctl.y1HpShcCoo, or2.u2) annotation (Line(points={{72,55},{80,55},{80,
          102},{98,102}}, color={255,0,255}));
  connect(ctl.y1HpShcHea, or2.u1) annotation (Line(points={{72,57},{72,58},{78,
          58},{78,110},{98,110}}, color={255,0,255}));
  connect(or2.y, y1HpShc_actual1.y1)
    annotation (Line(points={{122,110},{138,110}}, color={255,0,255}));
  connect(y1HpShc_actual1.y1_actual, ctl.u1HpShc_actual) annotation (Line(
        points={{162,110},{174,110},{174,134},{12,134},{12,44},{28,44}}, color=
          {255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-240,-240},{240,240}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/AirToWaterPolyvalent.mos"
        "Simulate and plot"),
    Documentation(
      revisions="<html>
<ul>
<li>
May 25, 2026, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.AirToWater\">
Buildings.Templates.Plants.Controls.HeatPumps.AirToWater</a>
with instance <code>ctl</code> that controls a polyvalent heat pump plant with two
equally-sized 2-pipe air-source heat pumps (ASHPs) in a lead-lag relationship, and
an additional 4-pipe ASHP that is prioritized when servicing simultaneous heating
and cooling loads.
</p>
<p>
Simulating this model shows how the controller responds to a varying load by 
</p>
<ul>
<li>
staging or unstaging the HPs and associated primary pumps,
</li>
<li>
rotating lead/lag alternate equipment to ensure even wear,
</li>
<li>
resetting the supply temperature and remote differential pressure 
in both the CHW and HW loops based on the valve position,
</li>
<li>
staging the secondary pumps.
</li>
</ul>
</html>"),
experiment(
      StopTime=86400.0,
      Tolerance=1e-06));
end AirToWaterPolyvalent;
