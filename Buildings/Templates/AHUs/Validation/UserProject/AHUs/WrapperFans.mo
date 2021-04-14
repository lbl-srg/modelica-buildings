within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model WrapperFans
  extends Buildings.Templates.AHUs.VAVSingleDuct_wrapper(
    typRel=Buildings.Templates.Types.ReliefReturn.ReturnFanPressure,
    typFanSupPos=Buildings.Templates.Types.FanSupplyPosition.DrawThrough,
    typFanSup=Buildings.Templates.Types.Fan.SingleVariable,
    nZon=1,
    nGro=1,
    id="VAV_1");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WrapperFans;
