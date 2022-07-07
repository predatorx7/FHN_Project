String singularOrPluralWhen(int value, String singular, String plural) {
  if (value == 1) {
    return singular;
  }
  return plural;
}
