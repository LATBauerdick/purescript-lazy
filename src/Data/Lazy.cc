///////////////////////////////////////////////////////////////////////////////
//
// Module      :  Lazy.cc
// Copyright   :  (c) Andy Arvanitis 2016
// License     :  MIT
//
// Maintainer  :  Andy Arvanitis <andy.arvanitis@gmail.com>
// Stability   :  experimental
// Portability :
//
// Lazy FFI functions
//
///////////////////////////////////////////////////////////////////////////////
//

#include <thread>
#include <mutex>
#include "Lazy.hh"

namespace Data_Lazy {

  using namespace PureScript;

  class Deferred {
    public:
      Deferred(const any& f) : thunk(f), value(nullptr) {}
      Deferred() = delete;

      auto force() -> const any& {
        std::call_once(flag, [&](){ value = thunk(unit); });
        return value;
      }
    private:
      std::once_flag flag;
      const any thunk;
      any value;
  };

  // foreign import defer :: forall a. (Unit -> a) -> Lazy a
  //
  auto defer(const any& f) -> any {
    return make_managed<Deferred>(f);
  }

  // foreign import force :: forall a. Lazy a -> a
  //
  auto force(const any& l) -> any {
    return cast<Deferred>(l).force();
  }

}
