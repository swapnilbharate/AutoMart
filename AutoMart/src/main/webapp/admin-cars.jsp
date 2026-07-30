<%@ page import="java.util.*, java.text.NumberFormat, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Car> cars = (List<Car>) request.getAttribute("cars");
    List<Brand> brands = (List<Brand>) request.getAttribute("brands");
    Car editCar = (Car) request.getAttribute("editCar");
    boolean editing = editCar != null;
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<style>

body {
    background: #99f6e4;



.ac-wrap { max-width: 1200px; margin: 0 auto; padding: 36px 24px 60px; }

.ac-heading { margin-bottom: 28px; }
.ac-heading h2 { margin: 0 0 4px; font-size: 1.75rem; font-weight: 800; color: #0f172a; }
.ac-heading p  { margin: 0; color: #0e7490; font-size: 0.95rem; }

.ac-card {
    background: #ffffff;
    border-radius: 14px;
    border: 1.5px solid #a5f3fc;
    box-shadow: 0 4px 24px rgba(8,145,178,0.15);
    margin-bottom: 28px;
    overflow: hidden;
}

.ac-card-hd {
    background: linear-gradient(135deg, #0f766e 0%, #0d9488 100%);
    padding: 16px 24px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.ac-card-hd h3 { margin: 0; color: #fff; font-size: 1.05rem; font-weight: 700; }
.ac-badge {
    margin-left: 8px;
    background: rgba(255,255,255,0.25);
    color: #fff;
    font-size: 0.78rem; font-weight: 700;
    padding: 2px 10px; border-radius: 20px;
}

.ac-card-body { padding: 28px 24px; }

.ac-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px 20px;
}
.ac-grid .full { grid-column: 1 / -1; }

.ac-field { display: flex; flex-direction: column; gap: 6px; }
.ac-field label {
    font-size: 0.78rem; font-weight: 700;
    color: #334155; text-transform: uppercase; letter-spacing: 0.04em;
}
.ac-field input,
.ac-field select,
.ac-field textarea {
    width: 100%; padding: 10px 13px;
    border: 1.5px solid #a5f3fc; border-radius: 8px;
    font-size: 0.92rem; font-family: inherit; color: #0f172a;
    background: #f0fdff;
    transition: border-color .2s, box-shadow .2s;
    box-sizing: border-box;
}
.ac-field input:focus,
.ac-field select:focus,
.ac-field textarea:focus {
    outline: none;
    border-color: #0891b2;
    box-shadow: 0 0 0 3px rgba(8,145,178,0.15);
    background: #fff;
}
.ac-field textarea { min-height: 100px; resize: vertical; }

.ac-checkbox-row {
    display: flex; align-items: center; gap: 10px;
    padding: 10px 13px;
    background: #ecfeff; border: 1.5px solid #a5f3fc; border-radius: 8px;
}
.ac-checkbox-row input[type="checkbox"] { width: 17px; height: 17px; accent-color: #0891b2; cursor: pointer; }
.ac-checkbox-row span { font-size: 0.9rem; color: #334155; font-weight: 600; }

.ac-actions {
    display: flex; gap: 12px; margin-top: 6px;
    padding-top: 20px; border-top: 1px solid #cffafe;
}
.ac-btn-primary {
    display: inline-flex; align-items: center; gap: 7px;
    padding: 11px 26px;
    background: linear-gradient(135deg, #0f766e, #0d9488);
    color: #fff; border: none; border-radius: 8px;
    font-weight: 700; font-size: 0.93rem; cursor: pointer;
    box-shadow: 0 4px 12px rgba(15,118,110,0.28);
    transition: transform .15s, box-shadow .15s;
    font-family: inherit;
}
.ac-btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(15,118,110,0.36); }
.ac-btn-cancel {
    display: inline-flex; align-items: center;
    padding: 11px 22px;
    background: #f1f5f9; color: #475569;
    border: 1.5px solid #cbd5e1; border-radius: 8px;
    font-weight: 700; font-size: 0.93rem; text-decoration: none;
    transition: background .15s;
}
.ac-btn-cancel:hover { background: #e2e8f0; }

/* ── Table ── */
.ac-tbl-wrap { overflow-x: auto; border-radius: 10px; border: 2.5px solid #0e7490; }
.ac-tbl {
    width: 100%; border-collapse: collapse;
    font-size: 0.89rem;
}
.ac-tbl thead tr {
    background: linear-gradient(135deg, #0f766e, #0d9488);
}
.badge-sd {
    background: #FEE2E2;
    color: #DC2626;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: .5px;
}

/* ── Responsive Mobile Cards ── */
@media (max-width: 800px) {
    .ac-tbl-wrap { overflow: visible !important; }
    .ac-tbl, .ac-tbl thead, .ac-tbl tbody, .ac-tbl th, .ac-tbl td, .ac-tbl tr {
        display: block !important;
        width: 100% !important;
        white-space: normal !important;
        box-sizing: border-box;
    }
    .ac-tbl thead tr { display: none !important; }
    .ac-tbl tr {
        margin-bottom: 20px !important;
        border: 1px solid #ccc !important;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        background: #fff;
    }
    .ac-tbl td {
        position: relative !important;
        padding: 10px 10px 10px 40% !important;
        text-align: right !important;
        border: none !important;
        border-bottom: 1px solid #eee !important;
        min-height: 40px;
    }
    .ac-tbl td:last-child { border-bottom: none !important; }
    .ac-tbl td::before {
        content: attr(data-label);
        position: absolute;
        left: 12px;
        width: 35%;
        text-align: left;
        font-weight: 600;
        color: #64748B;
        top: 50%;
        transform: translateY(-50%);
        font-size: 0.75rem;
        text-transform: uppercase;
    }
    .ac-tbl td form { display: inline-block; }
}

.ac-tbl thead th {
    padding: 13px 15px;
    text-align: left;
    font-size: 0.76rem; font-weight: 700;
    color: #fff; text-transform: uppercase; letter-spacing: 0.05em;
    border-right: 2px solid rgba(255,255,255,0.3);
    border-bottom: 2.5px solid #0e7490;
    white-space: nowrap;
}
.ac-tbl thead th:last-child { border-right: none; }

.ac-tbl tbody tr {
    border-bottom: 2px solid #0e7490;
    transition: background .15s;
}
.ac-tbl tbody tr:last-child { border-bottom: none; }
.ac-tbl tbody tr:nth-child(even) { background: #f0fdff; }
.ac-tbl tbody tr:hover { background: #cffafe !important; }

.ac-tbl tbody td {
    padding: 12px 15px;
    vertical-align: middle;
    border-right: 2px solid #0e7490;
    color: #1e293b;
}
.ac-tbl tbody td:last-child { border-right: none; }

.c-num  { color: #94a3b8; font-size: 0.8rem; font-weight: 700; text-align: center; }
.c-name { font-weight: 700; color: #0f172a; }
.c-brand {
    display: inline-block; padding: 3px 11px;
    background: #e0f2fe; color: #0369a1;
    border: 1px solid #bae6fd;
    border-radius: 20px; font-size: 0.76rem; font-weight: 700;
}
.c-price { font-weight: 800; color: #ea580c; white-space: nowrap; }
.c-city  { color: #64748b; font-size: 0.86rem; }
.c-year  { color: #64748b; }

.badge-av {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 4px 11px; background: #dcfce7; color: #15803d;
    border-radius: 20px; font-size: 0.76rem; font-weight: 700;
    border: 1px solid #bbf7d0;
}
.badge-sold {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 4px 11px; background: #fee2e2; color: #b91c1c;
    border-radius: 20px; font-size: 0.76rem; font-weight: 700;
    border: 1px solid #fecaca;
}

.ac-act { display: flex; gap: 7px; align-items: center; }
.btn-edit {
    display: inline-flex; align-items: center; gap: 4px;
    padding: 6px 13px; background: #e0f2fe; color: #0369a1;
    border: 1px solid #bae6fd; border-radius: 6px;
    font-size: 0.79rem; font-weight: 700; text-decoration: none;
    transition: background .15s;
}
.btn-edit:hover { background: #bae6fd; }
.btn-del {
    display: inline-flex; align-items: center; gap: 4px;
    padding: 6px 13px; background: #fee2e2; color: #b91c1c;
    border: 1px solid #fecaca; border-radius: 6px;
    font-size: 0.79rem; font-weight: 700; cursor: pointer;
    font-family: inherit; transition: background .15s;
}
.btn-del:hover { background: #fecaca; }

.ac-empty { text-align: center; padding: 42px 20px; color: #94a3b8; }

@media (max-width: 900px) { .ac-grid { grid-template-columns: repeat(2,1fr); } }
@media (max-width: 600px) { .ac-grid { grid-template-columns: 1fr; } .ac-card-body { padding: 18px 14px; } }
</style>

<div class="ac-wrap">

    <div class="ac-heading">
        <h2>Vehicle Listings</h2>
        <p>Add, update, delete, and upload images for marketplace cars.</p>
    </div>

    <!-- Form Card -->
    <div class="ac-card">
        <div class="ac-card-hd">
            <h3><%=editing ? "Update Vehicle" : "Add New Vehicle"%></h3>
        </div>
        <div class="ac-card-body">
            <form action="<%=ctx%>/admin/cars" method="post" enctype="multipart/form-data" data-validate>
                <input type="hidden" name="action" value="<%=editing ? "update" : "create"%>">
                <% if (editing) { %><input type="hidden" name="carId" value="<%=editCar.getCarId()%>"><% } %>

                <div class="ac-grid">

                    <div class="ac-field">
                        <label>Brand</label>
                        <select required name="brandId">
                            <% for (Brand brand : brands) { %>
                            <option value="<%=brand.getBrandId()%>" <%=editing && brand.getBrandId() == editCar.getBrandId() ? "selected" : ""%>><%=brand.getBrandName()%></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="ac-field">
                        <label>Car Name</label>
                        <input required name="carName" value="<%=editing ? editCar.getCarName() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Model</label>
                        <input required name="model" value="<%=editing ? editCar.getModel() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Manufacturing Year</label>
                        <input required type="number" name="manufacturingYear" value="<%=editing ? editCar.getManufacturingYear() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Fuel</label>
                        <select required name="fuelType">
                            <% for (String f : Arrays.asList("Petrol","Diesel","CNG","Electric","Hybrid")) { %>
                            <option <%=editing && f.equals(editCar.getFuelType()) ? "selected" : ""%>><%=f%></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="ac-field">
                        <label>Transmission</label>
                        <select required name="transmissionType">
                            <option <%=editing && "Manual".equals(editCar.getTransmissionType()) ? "selected" : ""%>>Manual</option>
                            <option <%=editing && "Automatic".equals(editCar.getTransmissionType()) ? "selected" : ""%>>Automatic</option>
                        </select>
                    </div>

                    <div class="ac-field">
                        <label>Mileage</label>
                        <input required type="number" step="0.01" name="mileage" value="<%=editing ? editCar.getMileage() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Color</label>
                        <input required name="color" value="<%=editing ? editCar.getColor() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Price</label>
                        <input required type="number" step="0.01" name="price" value="<%=editing ? editCar.getPrice() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>City</label>
                        <input required name="city" value="<%=editing ? editCar.getCity() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Seller Name</label>
                        <input required name="sellerName" value="<%=editing ? editCar.getSellerName() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Seller Phone</label>
                        <input required name="sellerPhone" value="<%=editing ? editCar.getSellerPhone() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Seller Email</label>
                        <input required type="email" name="sellerEmail" value="<%=editing ? editCar.getSellerEmail() : ""%>">
                    </div>

                    <div class="ac-field">
                        <label>Status</label>
                        <select required name="status">
                            <option <%=editing && "AVAILABLE".equals(editCar.getStatus()) ? "selected" : ""%>>AVAILABLE</option>
                            <option <%=editing && "SOLD".equals(editCar.getStatus()) ? "selected" : ""%>>SOLD</option>
                        </select>
                    </div>

                    <div class="ac-field">
                        <label>Upload Images</label>
                        <input type="file" name="images" accept="image/*" multiple>
                    </div>

                    <div class="ac-field">
                        <label>Featured</label>
                        <div class="ac-checkbox-row">
                            <input type="checkbox" name="featured" <%=editing && editCar.isFeatured() ? "checked" : ""%>>
                            <span>Mark as Featured Car</span>
                        </div>
                    </div>

                    <div class="ac-field full">
                        <label>Description</label>
                        <textarea required name="description"><%=editing ? editCar.getDescription() : ""%></textarea>
                    </div>

                </div>

                <div class="ac-actions">
                    <button class="ac-btn-primary" type="submit"><%=editing ? "Update Vehicle" : "Add Vehicle"%></button>
                    <% if (editing) { %><a class="ac-btn-cancel" href="<%=ctx%>/admin/cars">Cancel</a><% } %>
                </div>

            </form>
        </div>
    </div>

    <!-- Listings Table Card -->
    <div class="ac-card">
        <div class="ac-card-hd">
            <h3>Current Listings <span class="ac-badge"><%=cars.size()%> cars</span></h3>
        </div>
        <div class="ac-card-body">
            <% if (cars.isEmpty()) { %>
            <div class="ac-empty">
                <p>No vehicles listed yet. Add your first car above.</p>
            </div>
            <% } else { %>
            <div class="ac-tbl-wrap">
                <table class="ac-tbl">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Car Name</th>
                            <th>Brand</th>
                            <th>Year</th>
                            <th>Fuel</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>City</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% int i = 1; for (Car car : cars) { %>
                        <tr>
                            <td data-label="#" class="c-num"><%=i++%></td>
                            <td data-label="Car Name"><span class="c-name"><%=car.getCarName()%></span></td>
                            <td data-label="Brand"><span class="c-brand"><%=car.getBrandName()%></span></td>
                            <td data-label="Year" class="c-year"><%=car.getManufacturingYear()%></td>
                            <td data-label="Fuel"><%=car.getFuelType()%></td>
                            <td data-label="Price" class="c-price"><%=money.format(car.getPrice())%></td>
                            <td data-label="Status">
                                <% if ("AVAILABLE".equals(car.getStatus())) { %>
                                    <span class="badge-av">Available</span>
                                <% } else { %>
                                    <span class="badge-sd">Sold</span>
                                <% } %>
                            </td>
                            <td data-label="City"><%=car.getCity()%></td>
                            <td data-label="Actions">
                                <div class="ac-act">
                                    <a class="btn-edit" href="<%=ctx%>/admin/cars?editId=<%=car.getCarId()%>">Edit</a>
                                    <form action="<%=ctx%>/admin/cars" method="post" style="display:inline" onsubmit="return confirm('Delete this car?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="carId" value="<%=car.getCarId()%>">
                                        <button class="btn-del" type="submit">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

</div>

<%@ include file="/WEB-INF/footer.jsp" %>
