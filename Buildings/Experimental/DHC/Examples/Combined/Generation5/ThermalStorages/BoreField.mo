within Buildings.Experimental.DHC.Examples.Combined.Generation5.ThermalStorages;
model BoreField "Geothermal borefield model"
  extends Buildings.Fluid.Geothermal.Borefields.TwoUTubes(
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tLoaAgg(displayUnit="h") = 3600,
    final nSeg=5,
    TExt0_start=282.55,
    final z0=10,
    final dT_dz=0.02,
    final dynFil=true,
    borFieDat(
      final filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
          kFil=2.0,
          cFil=3040,
          dFil=1450),
      final soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(
          kSoi=2.3,
          cSoi=1000,
          dSoi=2600),
      final conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        dp_nominal=dpBorFie_nominal,
        mBor_flow_nominal=1.0,
        hBor=hBor,
        rBor=0.095,
        nBor=350,
        cooBor=cooBor,
        dBor=1,
        rTub=0.02,
        kTub=0.5,
        eTub=0.0037,
        xC=0.05)),
    show_T=true);
  /* 
  Some parameters (nBor, mBor_flow_nominal) cannot be propagated down to 
  borFieDat.conDat otherwise Dymola fails to expand.
  We assign them literally within borFieDat.conDat and propagate them up here.
  */
  parameter Integer nBor = borFieDat.conDat.nBor
    "Length of borehole"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Height hBor = 300
    "Total height of the borehole";
  parameter Real dxyBor = 10
    "Distance between boreholes";
  final parameter Modelica.SIunits.Length cooBor[nBor, 2]=
    {dxyBor * {mod(i - 1, 10), floor((i - 1)/10)} for i in 1:nBor}
    "Cartesian coordinates of the boreholes in meters";
  parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal=
    borFieDat.conDat.mBor_flow_nominal
    "Nominal mass flow rate per borehole"
    annotation (Dialog(group="Nominal condition"));
  /*
  1 kg/s in double-U DN40 HDPE yields 120 Pa/m in each tube.
  We add 30% singular pressure drop.
  */
  parameter Modelica.SIunits.Pressure dpBorFie_nominal(displayUnit="Pa")=
    2 * hBor * 120 * (mBor_flow_nominal / 1.0)^2 * 1.30
    "Pressure losses for the entire borefield"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(final unit="W")
    "Rate at which heat is extracted from soil"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
      iconTransformation(extent={{100,-64},{140,-24}})));
equation
  connect(gaiQ_flow.y, Q_flow) annotation (Line(points={{1,80},{14,80},{14,54},{
          96,54},{96,-40},{110,-40}},
                                    color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model represents a borefield composed of 350 boreholes,
with the following main assumptions.
</p>
<ul>
<li>
The soil is made of sandstone.
</li>
<li>
The boreholes are filled with a bentonite grout.
</li>
<li>
The boreholes have a height of 300 m and a diameter of 190 mm.
They are discretized vertically in five segments.
</li>
<li>
A distance of 10 m between each borehole is considered.
</li>
<li>
HDPE pipes with a diameter of 40 mm are considered, in a
double U-tube parallel configuration.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Updated documentation.
</li>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end BoreField;
