within Buildings.DHC.Examples.Combined.BaseClasses;
model Borefield "Geothermal borefield model"
  extends Buildings.Fluid.Geothermal.Borefields.TwoUTubes(
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tLoaAgg(displayUnit="h") = 3600,
    final nSeg=5,
    TExt0_start=282.55,
    final z0=10,
    final dT_dz=0.02,
    final dynFil=true,
    borFieDat(
      filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
          kFil=2.0,
          cFil=3040,
          dFil=1450),
      soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(
          kSoi=2.3,
          cSoi=1000,
          dSoi=2600),
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        dp_nominal=35000,
        hBor=300,
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
  Some parameters (such as nBor) cannot be propagated down to
  borFieDat.conDat otherwise Dymola fails to expand.
  We assign them literally within borFieDat.conDat and propagate them up here
  to compute dependent parameters.
  */
  parameter Integer nBor = borFieDat.conDat.nBor
    "Number of boreholes"
    annotation(Evaluate=true);
  parameter Real dxyBor = 10
    "Distance between boreholes";
  final parameter Modelica.Units.SI.Length cooBor[nBor,2]={dxyBor*{mod(i - 1,
      10),floor((i - 1)/10)} for i in 1:nBor}
    "Cartesian coordinates of the boreholes in meters";
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
January 8, 2024, by David Blum:<br/>
Moved to <code>Buildings.DHC.Examples.Combined.BaseClasses.Borefield</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3628\">
issue 3628</a>.
</li>
<li>
May 31, 2023, by Michael Wetter:<br/>
Removed <code>final</code> modifier for <code>borFieDat</code> to allow record to be replaced
in models that extend this model.
</li>
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
end Borefield;
