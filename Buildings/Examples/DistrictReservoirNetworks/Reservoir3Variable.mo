within Buildings.Examples.DistrictReservoirNetworks;
model Reservoir3Variable
  "Reservoir network with optimized controller"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.DistrictReservoirNetworks.BaseClasses.RN_BaseModel(
      datDes(
        mDisPip_flow_nominal=69.5,
        RDisPip=250,
        epsPla=0.91),
        pumpBHS(m_flow_nominal=0.5*datDes.mSto_flow_nominal));
  BaseClasses.Networks.Controls.MainPump conMaiPum(
    nMix=3,
    nSou=2,
    TMin=279.15,
    TMax=290.15,
    use_temperatureShift=false)
    annotation (Placement(transformation(extent={{-18,-300},{2,-280}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiConMaiPum(
    final k=1.4*datDes.mDisPip_flow_nominal)
    "Gain for mass flow rate"
    annotation (Placement(transformation(extent={{20,-300},{40,-280}})));
equation
  connect(senTMixHos.T, conMaiPum.TMix[1]) annotation (Line(points={{86.6,-92},{100,
          -92},{100,-114},{28,-114},{28,-270},{-36,-270},{-36,-285.333},{-20,-285.333}},
                                                                     color={0,0,
          127}));
  connect(senTMixApa.T, conMaiPum.TMix[2]) annotation (Line(points={{86.6,118},{26,
          118},{26,-268},{-30,-268},{-30,-284},{-20,-284}}, color={0,0,127}));
  connect(senTMixOff.T, conMaiPum.TMix[3]) annotation (Line(points={{-4.44089e-16,246.6},
          {-4.44089e-16,258},{-32,258},{-32,-282.667},{-20,-282.667}},
                                     color={0,0,127}));
  connect(senTMixHos.T, conMaiPum.TSouIn[1]) annotation (Line(points={{86.6,-92},{100,
          -92},{100,-114},{28,-114},{28,-270},{-36,-270},{-36,-291},{-20,-291}},
                                                             color={0,0,127}));
  connect(senTMixBor.T, conMaiPum.TSouOut[1]) annotation (Line(points={{-86.6,-300},{
          -98,-300},{-98,-290},{-38,-290},{-38,-297},{-20,-297}},
                                            color={0,0,127}));
  connect(senTMixBor.T, conMaiPum.TSouIn[2]) annotation (Line(points={{-86.6,-300},{
          -98,-300},{-98,-290},{-38,-290},{-38,-289},{-20,-289}},
                                            color={0,0,127}));
  connect(conMaiPum.TSouOut[2], senTMixPla.T) annotation (Line(points={{-20,-295},{
          -28,-295},{-28,-104},{-92,-104},{-92,-94},{-86.6,-94}},
                                            color={0,0,127}));
  connect(conMaiPum.y, gaiConMaiPum.u)
    annotation (Line(points={{4,-290},{18,-290}}, color={0,0,127}));
  connect(pumDisLop.m_flow_in, gaiConMaiPum.y)
    annotation (Line(points={{68,-290},{42,-290}}, color={0,0,127}));
  connect(pumpBHS.m_flow_in, gaiConMaiPum.y)
    annotation (Line(points={{50,-428},{50,-290},{42,-290}}, color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Reservoir3Variable.mos"
        "Simulate and plot"),
    experiment(
      StopTime=31536000,
      __Dymola_NumberOfIntervals=8760,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Model of reservoir network,
</p>
<p>
This model is identical to
<a href=\"Buildings.Examples.DistrictReservoirNetworks.Reservoir1Constant\">
Buildings.Examples.DistrictReservoirNetworks.Reservoir1Constant</a>
except for the pipe diameter and the control of the main circulation pump.
Rather than having a constant mass flow rate, the mass flow rate is varied
based on the mixing temperatures after each agent.
If these mixing temperatures are sufficiently far away from the minimum or mazimum
allowed loop temperature, then the mass flow rate is reduced to safe pump energy.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Reservoir3Variable;
