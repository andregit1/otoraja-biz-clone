class Term < ApplicationRecord
	enum terms_purpose: { to_bengkel: 1, to_customer: 2 }
end
