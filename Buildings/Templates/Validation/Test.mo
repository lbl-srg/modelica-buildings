within Buildings.Templates.Validation;
model Test
  record RecordOne
    parameter Integer typ = 1;
  end RecordOne;

  record RecordTwo
    extends RecordOne;
    parameter Integer p = 1;
  end RecordTwo;

  model One
    record RecOne = RecordOne;
    parameter RecOne rec;
  end One;

  model Two
    extends One(
      RecOne = RecordTwo);
    parameter RecOne rec;
  end Two;

  record TopLevel
    record RecOne = RecordOne;
    parameter RecOne rec;
  end TopLevel;

  TopLevel rec(
    RecOne = Two.RecOne);

  Two two(rec=rec.rec);
end Test;
