/// Tiny in-memory cache shared between repositories.
///
/// The backend needs the active account's numeric id for almost every
/// trading call (open positions, place order, history). Rather than
/// threading `accountId` through every controller/view (which would break
/// the "swap the repo, nothing else changes" promise from the README),
/// [AccountRepositoryHttp] stores the id here as soon as it fetches the
/// active account, and [TradingRepositoryHttp] reads it back.
///
/// This resets on app restart, same as the rest of the app's session state
/// for now (see README notes about adding persistence later).
class SessionStore {
  SessionStore._();

  static String? activeAccountId;
}
