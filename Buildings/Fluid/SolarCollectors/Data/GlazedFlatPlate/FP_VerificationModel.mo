within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_VerificationModel =
  Buildings.Fluid.SolarCollectors.Data.GenericEN12975 (
    final A=4.302,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final V=4.4/1000,
    final dp_nominal = 100,
    final mperA_flow_nominal=0.0241,
    final eta0=0.720,
    final IAMDiff=0.133,
    final a1=2.8312,
    final a2=0.00119,
    final b0=0,
    final b1=0,
    final mDry=484)
  "FP - All inputs necessary for verification of EN12975 models"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
<p>
No model on the <a href=\"http://www.solar-rating.org\"> Solar Rating and
Certification Corporation </a> website tested to EN12975 standards provides all
of the necessary information for modeling.
This data record was created to allow verification of EN12975 base classes
despite the limitations in available data.
</p>
</html>"));
